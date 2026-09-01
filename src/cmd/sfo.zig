const std = @import("std");
const ascii = std.ascii;
const Io = std.Io;
const meta = std.meta;
const mem = std.mem;
const zon = std.zon;
const ArrayList = std.ArrayList;
const fatal = std.process.fatal;

const sfo = @import("sfo");

pub fn run(
    init: std.process.Init,
    comptime ScType: type,
    sc: ScType,
    stderr: *Io.Writer,
) !void {
    if (sc.subcommands_opt) |subcommands| {
        switch (subcommands) {
            .build => |sub_sc| try buildSfo(init, @TypeOf(sub_sc), sub_sc, stderr),
            .manifest => |sub_sc| try createManifest(init, @TypeOf(sub_sc), sub_sc),
        }
    } else {
        try ScType.writeUsage(stderr);
    }
}

// TODO: allow overriding default SFO attributes through the CLI
fn createManifest(
    init: std.process.Init,
    comptime ArgsType: type,
    args: ArgsType,
) !void {
    const io = init.io;

    const out_path = args.positionals.OUTPUT;
    const out_file = Io.Dir.cwd().createFile(io, out_path, .{}) catch |err| {
        fatal("Failed to create output file {s} with {t}", .{ out_path, err });
    };
    defer out_file.close(io);

    const default_manifest: Manifest = .{
        .title = "My New Game",
        .title_id = "GAME00001",
        .content_id = "IV0000-GAME00001_00-MYGAME0000000000",
        .app_type = 1,
        .app_ver = "1.00",
        .version = "1.00",

        .attribute = 0,
        .category = "gd",
        .download_data_size = 0,
        .system_ver = 0,
    };

    var write_buf: [4096]u8 = undefined;
    var out_file_writer = out_file.writer(io, &write_buf);
    zon.stringify.serialize(default_manifest, .{}, &out_file_writer.interface) catch |err| {
        fatal("Failed to write manifest with {?t} ({t})", .{ out_file_writer.err, err });
    };
    out_file_writer.interface.flush() catch |err| {
        fatal("Failed to flush manifest with {?t} ({t})", .{ out_file_writer.err, err });
    };
}

fn buildSfo(
    init: std.process.Init,
    comptime ArgsType: type,
    args: ArgsType,
    stderr: *Io.Writer,
) !void {
    const io = init.io;
    const gpa = init.gpa;
    const arena = init.arena.allocator();

    var manifest = blk: {
        const in_path = args.positionals.INPUT;
        const in_file = Io.Dir.cwd().openFile(io, in_path, .{}) catch |err| {
            fatal("Failed to open input file {s} with {t}", .{ in_path, err });
        };
        defer in_file.close(io);

        var in_reader = in_file.reader(io, &.{});

        const manif_data = try in_reader.interface.allocRemainingAlignedSentinel(gpa, .unlimited, .@"16", 0);
        defer gpa.free(manif_data);

        var status = zon.parse.Diagnostics{};
        defer status.deinit(gpa);
        break :blk zon.parse.fromSliceAlloc(Manifest, gpa, manif_data, &status, .{}) catch |err| {
            switch (err) {
                error.OutOfMemory => fatal("No more memory available to parse manifest {s}", .{in_path}),
                error.ParseZon => {
                    try stderr.print("Failed to parse manifest {s} with the following errors:\n", .{in_path});
                    var errors = status.iterateErrors();
                    while (errors.next()) |st_err| {
                        const loc = st_err.getLocation(&status);
                        const msg = st_err.fmtMessage(&status);
                        try stderr.print("{s}:{}:{}: error: {f}\n", .{
                            in_path,
                            loc.line + 1,
                            loc.column + 1,
                            msg,
                        });

                        var notes = st_err.iterateNotes(&status);
                        while (notes.next()) |note| {
                            const note_loc = note.getLocation(&status);
                            const note_msg = note.fmtMessage(&status);
                            try stderr.print("{s}:{}:{}: note: {f}\n", .{
                                in_path,
                                note_loc.line + 1,
                                note_loc.column + 1,
                                note_msg,
                            });
                        }
                    }
                    std.process.abort();
                },
            }
        };
    };
    defer manifest.deinit(gpa);

    const out_path = args.positionals.OUTPUT;
    const out_file = Io.Dir.cwd().createFile(io, out_path, .{}) catch |err| {
        fatal("Failed to create output file {s} with {t}", .{ out_path, err });
    };
    defer out_file.close(io);

    var kv_pairs: ArrayList(sfo.KeyValue) = .empty;

    const field_names = comptime meta.fieldNames(@TypeOf(manifest));
    const field_types = comptime meta.fieldTypes(@TypeOf(manifest));
    inline for (field_names, field_types) |f_name, f_type| {
        const upper_key_name = try allocUpperStringZ(arena, f_name);
        try kv_pairs.append(arena, sfo.KeyValue{
            .key = upper_key_name,
            .value = switch (@typeInfo(f_type)) {
                .int => .{ .int32 = @as(f_type, @field(manifest, f_name)) },
                .pointer => |info| if (info.sentinel() != null)
                    .{ .utf8 = @as(f_type, @field(manifest, f_name)) }
                else
                    .{ .rsv4 = @as(f_type, @field(manifest, f_name)) },
                else => fatal("Unexpected type {s} used with field {s}", .{ @typeName(f_type), f_name }),
            },
        });
    }

    // sortPairs(kv_pairs.items);

    var write_buf: [4096]u8 = undefined;
    var out_file_writer = out_file.writer(io, &write_buf);
    sfo.write(&out_file_writer.interface, kv_pairs.items) catch |err| {
        fatal("Failed to write SFO with {?t} ({t})", .{ out_file_writer.err, err });
    };
    out_file_writer.interface.flush() catch |err| {
        fatal("Failed to flush SFO with {?t} ({t})", .{ out_file_writer.err, err });
    };
}

pub const Manifest = struct {
    title: [:0]const u8,
    title_id: [:0]const u8,
    content_id: [:0]const u8,
    app_type: i32,
    app_ver: [:0]const u8,
    version: [:0]const u8,

    attribute: i32,
    category: [:0]const u8,
    download_data_size: i32,
    system_ver: i32,

    const Self = @This();

    pub fn deinit(this: *Self, gpa: mem.Allocator) void {
        gpa.free(this.title);
        gpa.free(this.title_id);
        gpa.free(this.content_id);
        gpa.free(this.app_ver);
        gpa.free(this.version);
        gpa.free(this.category);
    }
};

fn allocUpperStringZ(allocator: std.mem.Allocator, ascii_string: [:0]const u8) ![:0]u8 {
    const result = try allocator.allocSentinel(u8, ascii_string.len, 0);
    _ = ascii.upperString(result[0..result.len], ascii_string[0..ascii_string.len]);
    return result;
}

fn keyValueSortFunc(context: void, lhs: sfo.KeyValue, rhs: sfo.KeyValue) bool {
    _ = context;
    return ascii.orderIgnoreCase(lhs.key, rhs.key) == .lt;
}
inline fn sortPairs(pairs: []sfo.KeyValue) void {
    mem.sort(sfo.KeyValue, pairs, {}, keyValueSortFunc);
}
