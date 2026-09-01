const std = @import("std");
const Io = std.Io;
const log = std.log.scoped(.gp4);
const fatal = std.process.fatal;

const zeit = @import("zeit");

const orbpack = @import("../root.zig");
const gp4 = orbpack.gp4;

pub fn run(
    init: std.process.Init,
    comptime ScType: type,
    sc: ScType,
    stderr: *Io.Writer,
) !void {
    if (sc.subcommands_opt) |subcommands| {
        switch (subcommands) {
            .manifest => |sub_sc| try createManifest(init, @TypeOf(sub_sc), sub_sc),
        }
    } else {
        try ScType.writeUsage(stderr);
    }
}

fn createManifest(
    init: std.process.Init,
    comptime ArgsType: type,
    args: ArgsType,
) !void {
    const arena = init.arena.allocator();
    const io = init.io;

    const now = zeit.instant(.{ .now = io }, &zeit.utc);

    const maybe_out_file = if (args.options.output) |out_path|
        Io.Dir.cwd().createFile(io, out_path, .{}) catch |err| {
            log.err("Failed to create output file {s} with {t}", .{ out_path, err });
            return err;
        }
    else
        null;
    defer if (maybe_out_file) |out_file| out_file.close(io);

    const content_id = args.positionals.CONTENT_ID;

    const files = blk: {
        const files_raw = args.options.file;
        const files = try arena.alloc(gp4.File, files_raw.items.len);

        for (files_raw.items, files) |cmd_file, *f| {
            var it = std.mem.splitScalar(u8, cmd_file, '=');
            const left_side = it.next() orelse {
                @branchHint(.unlikely);
                log.err("File argument \"{s}\" is invalid! It must be formatted as \"original_path=target_path\"", .{
                    cmd_file,
                });
                return error.InvalidArgument;
            };
            const right_side = it.next() orelse {
                @branchHint(.unlikely);
                log.err("Missing target file in file argument \"{s}\"!", .{cmd_file});
                return error.InvalidArgument;
            };

            f.* = .{
                .original_path = left_side,
                .target_path = right_side,
            };
        }
        break :blk files;
    };

    var write_buf: [4096]u8 = undefined;
    var out_writer = if (maybe_out_file) |out_file|
        out_file.writer(io, &write_buf)
    else
        Io.File.stdout().writer(init.io, &write_buf);

    try gp4.write(arena, &out_writer.interface, .{
        .volume_timestamp = now.time(),
        .content_id = content_id,
        .app_type = .full,
        .storage_type = .digital50,
        .files = files,
    });

    out_writer.interface.flush() catch |err| {
        log.err("Failed to flush manifest with {?t} ({t})", .{ out_writer.err, err });
        return err;
    };
}
