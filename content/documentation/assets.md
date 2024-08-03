---
.title = "Assets",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "documentation.shtml",
.tags = [],
--- 

## Assets in Zine
A Zine site can have 3 kinds of assets: **site**, **page**, and **build** assets.

## Site Assets
These assets are located under `assets_dir_path`. 

The main way of accessing site assets is by using the following Scripty expression: `$site.asset('logo.png')`.

Once you have an instance of an `Asset`, you can do three main things to it:

- `$site.asset('logo.png').size()` to obtain its size in bytes
- `$site.asset('logo.png').bytes()` to obtain its contents
- `$site.asset('logo.png').link()` to obtain a link to it

With `bytes` you can do clever things such as embedding the asset directly into the page itself, like so:

***clever-and-cursed.html***
```html
<img src="$site.asset('foo.png').bytes().base64().prefix('data:image/png;base64,')">
```

While `link` in comparison seems very boring, it's actually both the preferred
way in Zine to reference assets, and also its most clever asset feature.

**Calling `link` on an asset will cause Zine to install it in the output directory.** 
Conversely, accessing an asset *without* calling `link` on it will **not** cause it to be installed. 

One example of where this makes sense is when you have a Ziggy (or JSON) document that you want to use to build a page, but that is not meant to be included the final output.

***songs-list.html***
```html
<ul loop="$page.asset('songs.json').ziggy()">
  <li var="$loop.it.get!('name')"></li>
</ul>
```

**Note:** Zine uses [Ziggy](https://ziggy-lang.io) as its data serialization format of choice, but JSON documents happen to be a valid subset of Ziggy, so you can use them directly. 

### Static Site Assets
Some assets should be installed even if no layout or page refers to them. 

For example `favicon.ico` might not be referenced, but browsers will automatically try to fetch it.

Another example could be `.well-known` assets or files that might have special meaning for the hosting service that you're using. GitHub uses a file named `CNAME` to keep track of the custom domain configured for a given GitHub Pages website.

One last example would be font files only referenced inside of CSS files, as Zine currently lacks the ability to inspect CSS files.

To install assets unconditionally, list them in `static_assets` in your `build.zig`:

***build.zig***
```zig
pub fn build(b: *std.Build) !void {
    zine.website(b, .{
        .title = "Zine - Static Site Generator",
        .host_url = "https://zine-ssg.io",
        .layouts_dir_path = "layouts",
        .content_dir_path = "content",
        .assets_dir_path = "assets",
        .static_assets = &.{
            // Used by GitHub Pages
            "CNAME",
            // This asset is referenced in some inlined HTML in Markdown
            // which Zine is not yet able to analyze so as a temporary
            // hack we mark it as a static asset.
            "vscode-autoformatting.mp4",

            // Font referenced in CSS files
            "BebasNeue-Regular.ttf",
        },
    });
} 
```

## Page Assets
Page assets are the same as site assets, but are located inside of `content_dir_path`, next to the page that references them.

If you have an asset that is specific to only a single page of your website, you can conveniently place it next to it inside the content directory, but beware of respecting the expected content structure.

***shell***
```
content
├── blog
│   ├── first-post.md
│   └── index.md
└── index.md
```

In Zine, pages that are not named `index.md` (i.e. pages that don't define a section) must keep their assets under a directory with the same name.

***shell***
```
content
├── blog
│   ├── first-post
│   │   └── C.png
│   ├── first-post.md
│   ├── B.png
│   └── index.md
├── A.png
└── index.md
```

- `A.png` belongs to `content/index.md`
- `B.png` belongs to `content/blog/index.md`
- `C.png` belongs to `content/blog/first-post.md`

Note how `C.png` lives under `content/blog/first-post/` because it belongs to a non-section page.

Accessing a page asset can be done using `$page.asset('C.png')`.
Like all assets, they must be `link`ed to be installed in the output directory.

#### Note 
Inside of Markdown files you can use standard syntax `![](C.png)` and everything will work as expected (Zine will search for the asset in the right directory and will install it in the output directory). 

That said, Markdown processing in Zine has not yet reached its final form so expect news in the near future.

## Build Assets
If you have artifacts built using the Zig build system, you can use them in Zine by setting `build_assets` in your `build.zig`.

Accessing a build asset can be done using `$build.asset('foo')`.
Like all assets, they must be `link`ed to be installed in the output directory.

See the doc comments for `zine.BuildAsset` for more info.

## Next Steps
Make sure to familiarize yourself with the Scripty Reference Documentation in order to know what operations are available for assets and other kinds of data.

[Read the Scripty Reference Documentation](/documentation/scripty/)


