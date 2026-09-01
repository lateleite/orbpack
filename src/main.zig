const std = @import("std");
const mem = std.mem;
const assert = std.debug.assert;

const argzon = @import("argzon");

const cmd = @import("cmd.zig");

const cli = .{
    .name = "orbpack",
    .description = "PlayStation 4 package creating and utility tools",
    .subcommands = .{
        .{
            .name = "gp4",
            .description = "Creates and manipulates GP4 package manifest files",
            .subcommands = .{
                .{
                    .name = "manifest",
                    .description = "Generate a GP4 manifest file used to build PKGs",
                    .options = .{
                        .{
                            .short = 'f',
                            .long = "file",
                            .type = "string",
                            .description = "Files to include in the package",
                            .capacity = 256,
                        },
                        .{
                            .short = 'o',
                            .long = "output",
                            .type = "?string",
                            .description = "Output path for the new GP4 manifest file",
                        },
                    },
                    .positionals = .{
                        .{
                            .meta = .CONTENT_ID,
                            .type = "string",
                            .description = "The package's content ID",
                        },
                    },
                },
            },
        },
        .{
            .name = "sfo",
            .description = "Creates and manipulates SFO and SFO-related files",
            .note =
            \\Examples:
            \\  orbpack sfo manifest game_param.zon
            \\  orbpack sfo build game_param.zon param.sfo
            ,
            .subcommands = .{
                .{
                    .name = "build",
                    .description = "Transform a manifest file to an SFO file",
                    .positionals = .{
                        .{
                            .meta = .INPUT,
                            .type = "string",
                            .description = "Input path to an SFO manifest file",
                        },
                        .{
                            .meta = .OUTPUT,
                            .type = "string",
                            .description = "Output path for the new SFO param file",
                        },
                    },
                },
                .{
                    .name = "manifest",
                    .description = "Generate a manifest file used to build SFOs",
                    .positionals = .{
                        .{
                            .meta = .OUTPUT,
                            .type = "string",
                            .description = "Output path for the new SFO manifest file",
                        },
                    },
                },
            },
        },
    },
};

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    var stderr_buffer: [1024]u8 = undefined;
    var stderr_writer = std.Io.File.stderr().writer(io, &stderr_buffer);
    const stderr = &stderr_writer.interface;
    defer stderr.flush() catch {};

    const Args = argzon.Args(cli, .{});
    var args = try Args.parse(gpa, init.minimal.args, stderr, .{});
    defer args.free(gpa);

    // TODO: handle subcommand fatal errors
    const result = res: {
        if (args.subcommands_opt) |subcommands| {
            break :res switch (subcommands) {
                .gp4 => |sc| cmd.gp4.run(init, @TypeOf(sc), sc, stderr),
                .sfo => |sc| cmd.sfo.run(init, @TypeOf(sc), sc, stderr),
            };
        }
        try Args.writeUsage(stderr);
        return;
    };

    result catch |err| {
        try stderr.print("Command failed with {t}!\n", .{err});
        return;
    };
}
