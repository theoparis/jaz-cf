const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var cf_module = b.createModule(.{
        .source_file = .{ .path = "cf.zig" },
    });

    try b.modules.put(b.dupe("cf"), cf_module);

    const lib = b.addStaticLibrary(.{
        .name = "cf",
        .root_source_file = .{ .path = "cf.zig" },
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "cf.zig" },
        .target = target,
        .optimize = optimize,
    });
    main_tests.optimize = optimize;
    main_tests.target = target;

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
