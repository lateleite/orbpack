//
// GP4 manifest file implementation
// based off https://github.com/OpenOrbis/create-gp4
//
const std = @import("std");
const array_hash_map = std.array_hash_map;
const Io = std.Io;
const mem = std.mem;
const ArrayList = std.ArrayList;
const AutoArrayHashMap = std.array_hash_map.Auto;
const StringHashMap = std.hash_map.StringHashMapUnmanaged;
const ComponentIteratorPosix = std.fs.path.ComponentIterator(.posix, u8);
const ComponentPosix = ComponentIteratorPosix.Component;

const zeit = @import("zeit");

pub const AppType = enum {
    full,
    upgradable,
    demo,
    freemium,
};

pub const StorageType = enum {
    bd25,
    bd50,
    bd50_50,
    bd50_25,
    digital50,
    digital25,
};

pub const File = struct {
    original_path: []const u8,
    target_path: []const u8,
};

pub const BuildArguments = struct {
    volume_timestamp: zeit.Time,
    content_id: []const u8,
    app_type: AppType,
    storage_type: StorageType,
    files: []const File,
};

pub const WriteError = error{
    PathTooDeep,
} || mem.Allocator.Error || Io.Writer.Error;

pub fn write(alloc: mem.Allocator, writer: *Io.Writer, args: BuildArguments) WriteError!void {
    // build unique <dir> list, as that's required by LibOrbisPkg and the official SDK tools
    // TODO: do these nodes have to be unique?
    var dir_buffer: ArrayList(Directory) = .empty;
    defer {
        for (dir_buffer.items) |*dir| {
            dir.children.deinit(alloc);
        }
        dir_buffer.deinit(alloc);
    }

    // store indices to dir_buffer instead of pointers
    var dir_list: StringHashMap(usize) = .empty;
    defer dir_list.deinit(alloc);

    for (args.files) |file| {
        var it: ComponentIteratorPosix = .init(file.target_path);
        while (it.next()) |comp| {
            // skip last file name components
            if (it.peekNext() == null) {
                @branchHint(.unlikely);
                continue;
            }

            const result = try dir_list.getOrPut(alloc, comp.path);
            if (!result.found_existing) {
                try dir_buffer.append(alloc, .{
                    .name = comp.name,
                    .children = .empty,
                    .is_root = it.peekPrevious() == null,
                });
                const new_index = dir_buffer.items.len - 1;
                result.value_ptr.* = new_index;

                if (it.peekPrevious()) |prev| {
                    const parent_index = dir_list.get(prev.path).?;
                    const parent_dir = &dir_buffer.items[parent_index];
                    try parent_dir.children.append(alloc, new_index);
                }
            }
        }
    }

    try writer.writeAll(
        \\<?xml version="1.0"?>
        \\<psproject xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" fmt="gp4" version="1000">
        \\  <volume>
        \\    <volume_type>pkg_ps4_app</volume_type>
        \\    <volume_id>PS4VOLUME</volume_id>
        \\
    );

    // write volume timestamp
    try writer.writeAll("    <volume_ts>"); // no new line intentionally
    args.volume_timestamp.gofmt(writer, "2006-01-02 15:04:05") catch return error.WriteFailed;
    try writer.writeAll("</volume_ts>\n");

    try writer.print(
        \\    <package content_id="{s}" passcode="00000000000000000000000000000000" storage_type="{t}" app_type="{t}" />
        \\    <chunk_info chunk_count="1" scenario_count="1">
        \\      <chunks>
        \\        <chunk id="0" layer_no="0" label="Chunk #0" />
        \\      </chunks>
        \\      <scenarios default_id="0">
        \\        <scenario id="0" type="sp" initial_chunk_count="1" label="Scenario #0">0</scenario>
        \\      </scenarios>
        \\    </chunk_info>
        \\  </volume>
        \\
    , .{
        args.content_id,
        args.storage_type,
        args.app_type,
    });

    // emit individual files list
    if (args.files.len == 0) {
        @branchHint(.unlikely);
        try writer.writeAll("  <files img_no=\"0\" />\n");
    } else {
        try writer.writeAll("  <files img_no=\"0\">\n");
        for (args.files) |file| {
            try writer.print("    <file targ_path=\"{s}\" orig_path=\"{s}\" />\n", .{
                file.target_path,
                file.original_path,
            });
        }
        try writer.writeAll("  </files>\n");
    }

    try writer.writeAll("  <rootdir>\n");

    var emitted_dirs: StringHashMap(void) = .empty;
    defer emitted_dirs.deinit(alloc);

    var index_it = dir_list.valueIterator();
    while (index_it.next()) |index| {
        const dir = &dir_buffer.items[index.*];
        if (dir.is_root) {
            try emitDir(writer, dir_buffer.items, dir.*, 0);
        }
    }

    try writer.writeAll(
        \\  </rootdir>
        \\</psproject>
        \\
    );
}

fn emitDir(writer: *Io.Writer, dir_buffer: []const Directory, dir: Directory, depth: u8) WriteError!void {
    if (depth == 255) {
        @branchHint(.unlikely);
        return error.PathTooDeep;
    }

    try writer.splatByteAll(' ', 4 + depth * 2);
    if (dir.children.items.len > 0) {
        try writer.print("<dir targ_name=\"{s}\">\n", .{dir.name});

        for (dir.children.items) |child_index| {
            const child = dir_buffer[child_index];
            try emitDir(writer, dir_buffer, child, depth + 1);
        }

        try writer.splatByteAll(' ', 4 + depth * 2);
        try writer.writeAll("</dir>\n");
    } else {
        try writer.print("<dir targ_name=\"{s}\" />\n", .{dir.name});
    }
}

const Directory = struct {
    name: []const u8,
    children: ArrayList(usize),
    is_root: bool,
};

const testing = std.testing;

test "writing gp4" {
    var arena: std.heap.ArenaAllocator = .init(testing.allocator);
    defer arena.deinit();

    var result_writer: Io.Writer.Allocating = .init(testing.allocator);
    defer result_writer.deinit();

    try write(arena.allocator(), &result_writer.writer, .{
        .volume_timestamp = .{
            .year = 2026,
            .month = zeit.Month.aug,
            .day = 31,
            .hour = 19,
            .minute = 30,
            .second = 41,
            .millisecond = 496,
            .microsecond = 706,
            .nanosecond = 64,
            .offset = 0,
        },
        .content_id = "IV0000-ZIGG00001_00-ZIGTEST000000000",
        .app_type = .full,
        .storage_type = .digital50,
        .files = &.{
            .{ .original_path = "eboot.bin", .target_path = "eboot.bin" },
            .{ .original_path = "sce_sys/param.sfo", .target_path = "sce_sys/param.sfo" },
            .{ .original_path = "my_assets/shaders/character/pbr.sb", .target_path = "shaders/character/pbr.sb" },
            .{ .original_path = "my_assets/shaders/world/whatever.sb", .target_path = "shaders/world/whatever.sb" },
            .{ .original_path = "something.ini", .target_path = "a/really/long/path/that/should/make/for/some/really/deep/nodes/epic.txt" },
            .{ .original_path = "something.ini", .target_path = "a/really/long/path/that/should/make/for/interesting/results.jfif" },
        },
    });

    const output = result_writer.written();
    try testing.expectEqualStrings(
        \\<?xml version="1.0"?>
        \\<psproject xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" fmt="gp4" version="1000">
        \\  <volume>
        \\    <volume_type>pkg_ps4_app</volume_type>
        \\    <volume_id>PS4VOLUME</volume_id>
        \\    <volume_ts>2026-08-31 19:30:41</volume_ts>
        \\    <package content_id="IV0000-ZIGG00001_00-ZIGTEST000000000" passcode="00000000000000000000000000000000" storage_type="digital50" app_type="full" />
        \\    <chunk_info chunk_count="1" scenario_count="1">
        \\      <chunks>
        \\        <chunk id="0" layer_no="0" label="Chunk #0" />
        \\      </chunks>
        \\      <scenarios default_id="0">
        \\        <scenario id="0" type="sp" initial_chunk_count="1" label="Scenario #0">0</scenario>
        \\      </scenarios>
        \\    </chunk_info>
        \\  </volume>
        \\  <files img_no="0">
        \\    <file targ_path="eboot.bin" orig_path="eboot.bin" />
        \\    <file targ_path="sce_sys/param.sfo" orig_path="sce_sys/param.sfo" />
        \\    <file targ_path="shaders/character/pbr.sb" orig_path="my_assets/shaders/character/pbr.sb" />
        \\    <file targ_path="shaders/world/whatever.sb" orig_path="my_assets/shaders/world/whatever.sb" />
        \\    <file targ_path="a/really/long/path/that/should/make/for/some/really/deep/nodes/epic.txt" orig_path="something.ini" />
        \\    <file targ_path="a/really/long/path/that/should/make/for/interesting/results.jfif" orig_path="something.ini" />
        \\  </files>
        \\  <rootdir>
        \\    <dir targ_name="sce_sys" />
        \\    <dir targ_name="a">
        \\      <dir targ_name="really">
        \\        <dir targ_name="long">
        \\          <dir targ_name="path">
        \\            <dir targ_name="that">
        \\              <dir targ_name="should">
        \\                <dir targ_name="make">
        \\                  <dir targ_name="for">
        \\                    <dir targ_name="some">
        \\                      <dir targ_name="really">
        \\                        <dir targ_name="deep">
        \\                          <dir targ_name="nodes" />
        \\                        </dir>
        \\                      </dir>
        \\                    </dir>
        \\                    <dir targ_name="interesting" />
        \\                  </dir>
        \\                </dir>
        \\              </dir>
        \\            </dir>
        \\          </dir>
        \\        </dir>
        \\      </dir>
        \\    </dir>
        \\    <dir targ_name="shaders">
        \\      <dir targ_name="character" />
        \\      <dir targ_name="world" />
        \\    </dir>
        \\  </rootdir>
        \\</psproject>
        \\
    , output);
}
