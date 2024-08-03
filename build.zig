const std = @import("std");
const zine = @import("zine");

pub fn build(b: *std.Build) !void {
    zine.website(b, .{
        .title = "Zine - Static Site Generator",
        .host_url = "https://zine-ssg.io",
        .layouts_dir_path = "layouts",
        .content_dir_path = "content",
        .assets_dir_path = "assets",
        .static_assets = &.{
            "CNAME",
            // This asset is referenced in some inlined HTML in markdown
            // which Zine is not yet able to analyze so as a temporary
            // hack we mark it as a static asset.
            "vscode-autoformatting.mp4",

            // Fonts referenced in CSS files
            "BebasNeue-Regular.ttf",
            "Merriweather/Merriweather-Black.ttf",
            "Merriweather/Merriweather-BlackItalic.ttf",
            "Merriweather/Merriweather-Bold.ttf",
            "Merriweather/Merriweather-BoldItalic.ttf",
            "Merriweather/Merriweather-Italic.ttf",
            "Merriweather/Merriweather-Light.ttf",
            "Merriweather/Merriweather-LightItalic.ttf",
            "Merriweather/Merriweather-Regular.ttf",
        },
    });

    // This line creates a build step that generates an updated
    // Scripty reference file. Other sites will not need this
    // most probably, but at least it's an example of how Zine
    // can integrate neatly with other Zig build steps.
    zine.scriptyReferenceDocs(b, "content/documentation/scripty/index.md");
}
