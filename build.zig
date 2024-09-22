pub fn build(b: *std.Build) !void {
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = b.path("src/startup.zig"),
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .thumb,
            .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
            .os_tag = .freestanding,
            .abi = .eabihf,
        }),
        .optimize = b.standardOptimizeOption(.{}),
    });
    exe.setLinkerScript(b.path("stm32f401re.ld"));

    const exe_objcopy = exe.addObjCopy(.{ .format = .bin });
    const exe_install = b.addInstallArtifact(exe, .{});
    const exe_install_objcopy = b.addInstallBinFile(exe_objcopy.getOutput(), exe_objcopy.basename);
    const flash_run = b.addSystemCommand(&.{
        "openocd",
        "-f",
        "/usr/share/openocd/scripts/board/st_nucleo_f4.cfg",
        "-c",
        "init",
        "-c",
        "reset halt; flash write_image erase zig-out/bin/armandaleg.bin 0x08000000 bin",
        "-c",
        "flash verify_image zig-out/bin/armandaleg.bin 0x08000000 bin",
        "-c",
        "reset run; shutdown",
    });
    const flash_step = b.step("flash", "Flash the code to the target");

    b.getInstallStep().dependOn(&exe_install_objcopy.step);
    exe_install_objcopy.step.dependOn(&exe_install.step);
    flash_run.step.dependOn(&exe_install_objcopy.step);
    flash_step.dependOn(&flash_run.step);
}

const std = @import("std");
const name = "armandaleg";
