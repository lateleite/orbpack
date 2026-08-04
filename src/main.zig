const std = @import("std");
const mem = std.mem;
const assert = std.debug.assert;

const cmd = @import("cmd.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stderr_buffer: [1024]u8 = undefined;
    var stderr_writer = std.Io.File.stderr().writer(io, &stderr_buffer);
    const stderr = &stderr_writer.interface;
    defer stderr.flush() catch {};

    const args = init.minimal.args;
    var args_it = args.iterate();

    // skip the first argument since that's the command path used by the user.
    // TODO: use it in the error messages?
    const skip = args_it.skip();
    assert(skip);

    const tools = .{
        cmd.sfo,
    };

    const arg_cmd = blk: {
        if (args_it.next()) |next_arg| {
            if (!mem.eql(u8, next_arg, "help"))
                break :blk next_arg;
        }

        try stderr.writeAll(
            \\orbpack - PlayStation 4 package creating and utility tools 
            \\Usage:
            \\  orbpack [tool] [command] [any arguments]
            \\
            \\Available tools:
            \\
        );
        inline for (tools) |tool| {
            try tool.printUsage(stderr);
        }
        return;
    };

    // TODO: handle subcommand fatal errors
    const result, const printUsage = res: {
        inline for (tools) |tool| {
            const tool_name: []const u8 = comptime blk: {
                const orig_name = @typeName(tool);
                const expected_prefix = "cmd.";

                if (orig_name.len < expected_prefix.len)
                    @compileError("Tool's name \"" ++ orig_name ++ "\" must be prefixed with \"cmd.\"");

                const prefix_in_name = orig_name[0..expected_prefix.len];
                if (!mem.eql(u8, expected_prefix, prefix_in_name))
                    @compileError("Tool's name \"" ++ orig_name ++ "\" must be prefixed with \"cmd.\"");

                break :blk orig_name[expected_prefix.len..];
            };

            if (mem.eql(u8, arg_cmd, tool_name)) {
                break :res .{ tool.run(init, &args_it, stderr), &tool.printUsage };
            }
        }
        try stderr.print(
            \\Unknown tool '{s}' was used!
            \\
            \\Available tools:
            \\   - sfo
            \\   - help
            \\
        , .{arg_cmd});
        return;
    };

    result catch |err| {
        const fail_reason = switch (err) {
            else => |e| {
                try stderr.print(
                    "{s} found an unexpected error: {t}\n",
                    .{ arg_cmd, e },
                );
                return;
            },
            error.UnknownCommand => "Unknown command used in",
            error.MissingCommand => "Missing command in",
            error.MissingInputPath => "Missing input path in",
            error.MissingOutputPath => "Missing output path in",
        };

        try stderr.print(
            \\{1s} '{0s}'!
            \\{0s} usage:
            \\
        , .{ arg_cmd, fail_reason });
        try printUsage(stderr);
        return;
    };
}
