///
/// System File Object (SFO)
/// It's essentially a key-value list in binary.
/// Based on LibOrbisPkg and https://www.psdevwiki.com/ps4/Param.sfo
///
const std = @import("std");
const Io = std.Io;
const hash = std.hash;
const math = std.math;
const mem = std.mem;
const assert = std.debug.assert;

const layout = @import("sfo/layout.zig");
pub const DESCRIPTORS = layout.DESCRIPTORS;

/// Defines the data type of values.
pub const FmtType = enum(u16) {
    /// resource data, treated as an array of bytes.
    rsv4 = 0x4,
    /// null terminated UTF-8 string.
    utf8 = 0x204,
    /// `i32` in little endian.
    int32 = 0x404,
};

// in-file binary representations
const Header = extern struct {
    const MAGIC: [4]u8 = .{ 0x00, 0x50, 0x53, 0x46 }; // "\x00PSF"
    const VERSION = 0x101; // 1.01?

    magic: [4]u8,
    version: u32,
    keys_list_offset: u32,
    values_list_offset: u32,
    num_entries: u32,
};
const Entry = extern struct {
    key_offset: u16,
    type: FmtType,
    length: u32,
    max_length: u32,
    value_offset: u32,
};
comptime {
    assert(@sizeOf(Header) == 0x14);
    assert(@sizeOf(Entry) == 0x10);
}

/// High-level key-value pair representation.
/// Slice memory must be handled by users.
pub const KeyValue = struct {
    key: [:0]const u8,
    value: union(FmtType) {
        rsv4: []const u8,
        utf8: [:0]const u8,
        int32: i32,
    },

    pub inline fn getKeyLength(self: KeyValue) error{KeyTooLong}!u16 {
        return math.cast(u16, self.key.len + 1) orelse return error.KeyTooLong;
    }
    pub inline fn getValueLength(self: KeyValue) error{ValueTooLong}!u32 {
        return math.cast(u32, switch (self.value) {
            .rsv4 => |val| val.len,
            .utf8 => |val| val.len + 1,
            .int32 => @sizeOf(i32),
        }) orelse return error.ValueTooLong;
    }
    // TODO: move type validations out of this?
    pub fn getMaxValueLength(self: KeyValue) error{ UnknownKey, ValueTooLong, WrongValueType }!u16 {
        for (layout.DESCRIPTORS) |desc| {
            if (hash.Wyhash.hash(0, desc.name) != hash.Wyhash.hash(0, self.key))
                continue;
            if (@as(FmtType, desc.attributes) != @as(FmtType, self.value))
                return error.WrongValueType;

            const val_len = try self.getValueLength();
            const max_val_len = switch (desc.attributes) {
                .rsv4 => |attr| attr.max_len,
                .utf8 => |attr| attr.max_len,
                .int32 => @sizeOf(i32),
            };

            if (val_len > max_val_len)
                return error.ValueTooLong;
            return max_val_len;
        }

        return error.UnknownKey;
    }
};

/// Writes an SFO with a list of KeyValue pairs.
/// `writer` may be an AnyWriter/GenericWriter and requires no backing buffer.
/// `pairs` must be ordered alphabetically according to their key
// TODO: deduplicate values?
// TODO: sort pairs by keys?
pub fn write(writer: *Io.Writer, pairs: []const KeyValue) !void {
    // check if pairs are ordered, left < right
    // for (0..pairs.len - 1) |i| {
    //     const left = pairs[i];
    //     const right = pairs[i + 1];
    //     if (std.ascii.orderIgnoreCase(left.key, right.key) != .lt) {
    //         return error.UnorderedPairs;
    //     }
    // }

    // since writer is generic and doesn't allow accessing any previously written data,
    // pre-calculate the offsets where the key and value lists *should* be at.
    const num_entries = math.cast(u32, pairs.len) orelse return error.TooManyEntries;
    const keys_list_offset: u32 = @sizeOf(Header) + (@sizeOf(Entry) * num_entries);
    const values_list_offset = blk: {
        var cur = keys_list_offset;
        for (pairs) |kv| {
            const length = try kv.getKeyLength();
            cur = math.add(u32, cur, length) catch return error.TooManyKeys;
        }
        break :blk cur;
    };

    try writer.writeStruct(Header{
        .magic = Header.MAGIC,
        .version = Header.VERSION,
        .keys_list_offset = keys_list_offset,
        .values_list_offset = values_list_offset,
        .num_entries = num_entries,
    }, .little);

    try writer.flush();

    var cur_key_off: u16 = 0;
    var cur_val_off: u32 = 0;
    for (pairs) |kv| {
        const key_len = try kv.getKeyLength();
        const val_len = try kv.getValueLength();
        const max_val_len = try kv.getMaxValueLength();

        try writer.writeStruct(Entry{
            .key_offset = cur_key_off,
            .type = kv.value,
            .length = val_len,
            .max_length = max_val_len,
            .value_offset = cur_val_off,
        }, .little);

        cur_key_off = math.add(u16, cur_key_off, key_len) catch return error.TooManyKeys;
        cur_val_off = math.add(u32, cur_val_off, max_val_len) catch return error.TooManyValues;
    }

    try writer.flush();

    for (pairs) |kv| {
        const key_len = try kv.getKeyLength();
        try writer.writeAll(kv.key[0..key_len]);
    }

    try writer.flush();

    for (pairs) |kv| {
        switch (kv.value) {
            .rsv4 => |val| try writer.writeAll(val),
            .utf8 => |val| try writer.writeAll(val[0 .. val.len + 1]),
            .int32 => |val| try writer.writeInt(i32, val, .little),
        }
        const pad_len = try kv.getMaxValueLength() - try kv.getValueLength();
        try writer.splatByteAll(0, pad_len);
    }

    try writer.flush();
}

const testing = std.testing;

test "writing" {
    var buf: [512]u8 = undefined;
    var strm = Io.Writer.fixed(&buf);

    const pairs = [_]KeyValue{ .{
        .key = "TITLE",
        .value = .{ .utf8 = "PS4 Zig Test" },
    }, .{
        .key = "TITLE_ID",
        .value = .{ .utf8 = "ZIGG00001" },
    }, .{
        .key = "CONTENT_ID",
        .value = .{ .utf8 = "IV0000-ZIGG00001_00-ZIGTEST000000000" },
    }, .{
        .key = "APP_TYPE",
        .value = .{ .int32 = 1 },
    }, .{
        .key = "APP_VER",
        .value = .{ .utf8 = "1.00" },
    }, .{
        .key = "VERSION",
        .value = .{ .utf8 = "1.00" },
    }, .{
        .key = "ATTRIBUTE",
        .value = .{ .int32 = 0 },
    }, .{
        .key = "CATEGORY",
        .value = .{ .utf8 = "gd" },
    }, .{
        .key = "DOWNLOAD_DATA_SIZE",
        .value = .{ .int32 = 0 },
    }, .{
        .key = "SYSTEM_VER",
        .value = .{ .int32 = 0 },
    } };
    try write(&strm, &pairs);
    try strm.flush();

    const actual_result = strm.buffered();
    try testing.expectEqual(504, actual_result.len);
    try testing.expectEqual(0x955042d103581bde, std.hash.XxHash64.hash(0, actual_result));
}
