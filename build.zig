const std = @import("std");
const zine = @import("zine");

pub fn build(b: *std.Build) !void {
    b.getInstallStep().dependOn(&b.addFail(
        "this build.zig is only used to generate reference docs for scripty, run zine directly to edit the website.",
    ).step);
    // This line creates a build step that generates an updated
    // Scripty reference file. Other sites will not need this
    // most probably, but at least it's an example of how Zine
    // can integrate neatly with other Zig build steps.
    scriptyReferenceDocs(
        b,
        "content/docs/superhtml/scripty.smd",
        "content/docs/supermd/scripty.smd",
    );
}

pub fn scriptyReferenceDocs(
    b: *std.Build,
    shtml_output_file_path: []const u8,
    smd_output_file_path: []const u8,
) void {
    const zine_dep = b.dependencyFromBuildZig(
        zine,
        .{ .optimize = .Debug, .docgen = true },
    );

    const run_step = b.step(
        "docgen",
        "Regenerates Scripty reference docs",
    );

    {
        const run_docgen = b.addRunArtifact(
            zine_dep.artifact("shtml_docgen"),
        );

        const reference_md = run_docgen.addOutputFileArg(
            "shtml_scripty_reference.smd",
        );

        const wf = b.addUpdateSourceFiles();
        wf.addCopyFileToSource(reference_md, shtml_output_file_path);

        run_step.dependOn(&wf.step);
    }
    {
        const run_docgen = b.addRunArtifact(
            zine_dep.builder.dependency("supermd", .{}).artifact("docgen"),
        );

        const reference_md = run_docgen.addOutputFileArg(
            "smd_scripty_reference.smd",
        );

        const wf = b.addUpdateSourceFiles();
        wf.addCopyFileToSource(reference_md, smd_output_file_path);

        run_step.dependOn(&wf.step);
    }
}
