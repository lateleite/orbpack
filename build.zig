const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //
    // dependencies
    //
    const dep_argzon = b.dependency("argzon", .{});
    const mod_argzon = dep_argzon.module("argzon");
    const dep_zeit = b.dependency("zeit", .{});
    const mod_zeit = dep_zeit.module("zeit");

    //
    // the tool itself
    //
    const mod_orbpack = b.addModule("orbpack", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe_orbpack = b.addExecutable(.{
        .name = "orbpack",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .imports = &.{
                .{ .name = "argzon", .module = mod_argzon },
                .{ .name = "orbpack", .module = mod_orbpack },
                .{ .name = "zeit", .module = mod_zeit },
            },
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(exe_orbpack);

    //
    // tests
    //
    const tests_sfo = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .imports = &.{
                .{ .name = "zeit", .module = mod_zeit },
            },
            .target = target,
            .optimize = optimize,
        }),
    });

    const run_tests_all = b.addRunArtifact(tests_sfo);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests_all.step);

    //
    // check stages for ZLS
    //
    const step_check = b.step("check", "Check if the project compiles");

    const check_orbpack = b.addExecutable(.{
        .name = "mksfo",
        .root_module = mod_orbpack,
    });

    step_check.dependOn(&check_orbpack.step);
}
