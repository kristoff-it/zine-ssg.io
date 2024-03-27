const std = @import("std");
const zine = @import("zine");

pub fn build(b: *std.Build) !void {
    try zine.addWebsite(b, .{
        .title = "Zine Static Site Generator",
        .host_url = "https://zine-ssg.io",
        .layouts_dir_path = "layouts",
        .content_dir_path = "content",
        .static_dir_path = "static",
    });

    // This line creates a build step that generates an updated
    // Scripty reference file. Other sites will not need this
    // most probably, but at least it's an example of how Zine
    // can integrate neatly with other Zig build steps.
    zine.scriptyReferenceDocs(b, "content/documentation/scripty/index.md");
}
