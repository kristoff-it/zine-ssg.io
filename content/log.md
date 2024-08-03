---
{
    .title = "Changelog",
    .date = @date("2020-07-06T00:00:00"),
    .author = "Sample Author",
    .draft = false,
    .layout = "page.shtml",
    .tags = [],
} 
--- 
## About
This is a non-exhaustive, curated list of changes meant to help users quickly see what has improved since they last checked.

Refer to [the repository](https://github.com/kristoff-it/zine) and the [issue tracker](https://github.com/kristoff-it/zine/issues) for more in-depth information.

## Changes
<style>
pre {
  overflow: hidden;
  text-overflow: ellipsis;
}
pre:has(.superhtml) {
  overflow: hidden;
  text-overflow: unset;
  overflow-x: auto;
}
pre:has(.sh) {
  color: #111;
  background-color: #ccc;
  padding-left: 10px;
  text-align: center;
}
</style>
<script>
window.onload = function() {
  document.querySelectorAll("button").forEach(function (b) {b.addEventListener("click", function () {
      navigator.clipboard.writeText(b.parentElement.nextElementSibling.textContent);
    });
  });
}
</script>


### 2024-08-03

<button>copy</button>
```sh
zig fetch --save "git+https://github.com/kristoff-it/zine#v0.3.0"
```
**The Asset System update!**

- Zine has now an asset system with clearly defined semantics. Previously we kinda implemented informally what other static site generators offered (eg a static asset directory), while now Zine gained it's own spin on assets

  There's a new [Assets section in the docs](/documentation/assets/), read it to learn how assets now work in Zine. The most notable changes are:
    - Zine can now make use of artifacts generated via the Zig build system!
    - `static_dir_path` has become `assets_dir_path` (I also recommend renaming `static` to `assets`)
    - Page assets (eg images placed in the content directory next to the page they belong to) __now have one extra rule for file placement__, see the docs for more info on that (or let the error messages *gently* guide you)
- The dev server now by default opens a <strike>door</strike> port to 1990 if you don's specify `-Dport`
- `output_prefix` has been renamed to `output_path_prefix`
- In `MultilingualSite`, `variants` has been renamed to `localized variants`
- Scripty has gained a new `Asset` type and handful of new builtins, including adding the ability to query for the current `locale_code` in a multilingual website (`$site.localeCode()`)

### 2024-07-27 

<button>copy</button>
```sh
zig fetch --save "git+https://github.com/kristoff-it/zine#v0.2.0"
```
**The build system flexibility update (part 1)!** 
 
- Upgrading from v0.1: in your `build.zig` change `try zine.addWebsite` to `zine.website`.
- `addWebsite` and `addMultilingualWebsite` have been renamed to `website` and `multilingualWebsite` respectively (and now don't return an error anymore)
- To align with `std.Build`'s naming convention (where 'add' functions create steps but don't wire them to the default install step), `addWebsite` and `addMultilingualWebsite` are now more low-level functions for defining build pipelines that allow you to customize more things:
  - **You can have other build steps depend on the website being built** 
  - **You can specify if and how the development webserver is bound to a named step**
  - et cetera

  To learn how to use this more fine-grained API, look at the implementation of `website` and `multilingualWebsite`.

-  As suspected, in the last release I did not proprely wire the dependency on `zig-afl-kit` as a lazy dependency and that caused build errors to some. This is now fixed in this release. Sorry!

*The next item on the roadmap is to add an asset system to Zine in order to have the static content generation depend on other steps defined in your build script.*
  

### 2024-07-26 

<button>copy</button>
```sh
zig fetch --save "git+https://github.com/kristoff-it/zine#v0.1.3"
```
- Scripty strings now have `eql`, `contains` and `endsWith`. With a pinch of creativity you  can create menus that style differently the current active page:
  ```superhtml
  <div class="$page.permalink().endsWith('/blog/').then('selected', '')">
    Blog
  </div>
  ```
  Similarly, when printing out the list of pages in a section, you can filter-out occasional "miscellaneous" pages (as in belonging to the same section but unwanted in the current list):
  ```superhtml
  <div loop="$page.subpages()">
    <div if="$loop.it.permalink().contains('/blog/')">
      <a href="$loop.it.permalink() var="$loop.it.title"></a>
    </div>
  </div>
  ```
- The [SuperHTML CLI tool](https://github.com/kristoff-it/superhtml) was updated with two new commands:
  - `check`: checks HTML and SuperHTML template files for syntax errors, useful if you don't have / want LSP integration (see also `fmt` in such case).
  - `interface`: prints out the interface of a given SuperHTML template file, 
  useful to bootstrap a new SuperHTML template that extends another.

- Zine and some of its dependencies depend on [kristoff-it/zig-afl-kit](https://github.com/kristoff-it/zig-afl-kit) for fuzzing. I tried now to make it a lazy dependency so that users don't have to download it just to use Zine (as it's a dev-only dependency), but I haven't yet been able to fully test if I did so correctly.

### 2024-07-25 

<button>copy</button>
```sh
zig fetch --save "git+https://github.com/kristoff-it/zine#v0.1.0"
```
**Zine has finally reached a first tagged release!**

A lot has happened in these 4 months, so read this changelog to learn how to upgrade your Zine website.

The first thing that changed is the recommended way of updating your `build.zig.zon`. 

The second is that Zine now tracks the latest stable version of Zig, which is 0.13.0 at the moment of writing.

Now onto new features and breaking changes:

- The recommended GitHub Actions Workflow files for building Zine websites on Github have changed. The new version uses the [mlugg/setup-zig@v1](https://github.com/marketplace/actions/setup-zig-compiler) action that will automatically manage caching for you. It is **highly recommended** to update your scripts.

  - While you're at it, change `--summary all` to `--summary new`, which will only list the pages that were rebuilt.

- [SuperHTML](https://github.com/kristoff-it/superhtml) (Zine's templating language) dropped Tree Sitter as its HTML parser in favor of a handcrafted implementation that more closely follows the HTML5 spec. This brings us **significantly** improved error messages and other advantages.

  - [It's **highly** recommended you install and configure SuperHTML](https://github.com/kristoff-it/superhtml) as your language server for both HTML and SuperHTML Templates **in order to get in-editor diagnostics and kickass autoformatting**. The repo also offers a Tree Sitter grammar for SuperHTML that incudes a few visual improvements for tags and attributes that have semantic meaning.
  
    SuperHTML also has a [VSCode extension](https://marketplace.visualstudio.com/items?itemName=LorisCro.super).

  - SuperHTML follows the HTML5 spec much more closely and, while writing an HTML parser from scratch for it, I learned that self-closing tags (tags with a final `/`) are not a thing in HTML5, so now `<extend>` and `<super>` have been defined as [void elements](https://developer.mozilla.org/en-US/docs/Glossary/Void_element) in SuperHTML and want no final slash nor closing tag. 
    
    Note that SuperHTML will consider an error using self-closing tags in HTML (outside of a `<svg>` scope).

  - The correct file extension for templates is `.shtml`. **You must rename all your templates to the new file extension** otherwise you will get an error from SuperHTML when it sees non-HTML compliant syntax, since `<extend>` and `<super>` are recognized as void elements only in SuperHTML template files.

- Scripty has impoved as well: inside of nested loops, it is now possible to access outer `$loop` variables by doing `$loop.up()`. Each call to `up()` goes up one level.

  - This is thanks to the fact that interrupts were implemented in Scripty, opening the door to features that rely on the ability to pass from the outside values into scripty (`up()` relies on that since loops are a SuperHTML concept that Scripty is completely unaware of).

- For syntax highlighting, Zine uses a distribution of Tree Sitter that bundles a lot of grammars and highlighting queries from [Flow Control](https://github.com/neurocyte/flow). The dependency has now been updated to a new version that adds support for more languages.

That's mostly it. If you encounter bugs while updating, please don't hesitate to open a [new issue on GitHub](https://github.com/kristoff-it/zine/issues) **with a link to a reproduction**.



### 2024-03-26 

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine#e33a1d79b09e8532db60347a7ec4bd3413888977",
.hash = "12209f9be74fcc805c0f086e4a81ccca041354448f5b3592e04b6a6d1b4a95da5a26",
```
- Added support for multilingual websites. See the [corresponding docs page](/documentation/i18n/) for more info. Because of this change now the `AddWebsiteOptions` struct is slightly different, here's how to fix it:
  - Take the contents of `site` and move them top level, rename `base_url` to `host_url`.
- Related-but-distinct from the above, you can now specify an output prefix for your static site. The feature was added primarily for i18n purposes but can also be used in simple websites to add an arbitrary prefix.
- The markdown renderer now renders tables!
- Fixed a crash in the dev server that would trigger when refreshing the page multiple times in quick succession (the crash was related to websockets). There's still one remaining known bug related to this same problem though.
- The dev server now works on Windows (thanks Parzival-3141)
- New Scripty builtins:
   - Strings
      - `addPath()` similar to `suffix` but knows when to add a `/` or not.
      - `fmt()` replaces occurrences of `{}` in your strings with the provided string arguments.
   - Maps, refined the `get` family of functions
      - `get(key, fallback)` allows to get a key from a map and provide a fallback value
      - `get!(key)` errors out if the key doesn't exist
      - `get?(key)` returns null if the value is missing, to be used in conjunction with `if` attributes.       
### 2024-03-21 

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine#ecc72eb042af07f5b4690a35a7ca1dd9c6fd5b61",
.hash = "1220610a18236cd32936502bd7e762743e89ef70408638675420e453be41f1e83de4",
```
- Changed datetime library to [rockorager/zeit](https://github.com/rockorager/zeit/).
- If you put a `@date("...")` literal in your custom fields, it will be recognized as a date by Zine.
- A few improvements to bulitins:
  - `get?()`, `get!()` and `get()`: different ways of getting values out of Ziggy maps (i.e. custom fields).
  - `then()` on booleans now gives you the ability to create if-then-else expressions.
  - `gt` on integers.
  - `lt`, `eq`, `gt` on dates.

### 2024-03-20 

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine#d06884ec657abe87ab4f408b5dc3f336a6dcea9b",
.hash = "1220d3bc95a5343918d69d3478f27ebb4abe14613c159737af64cd2185151efd2fa1",
```
- **Zine now uses [Ziggy](https://ziggy-lang.io) as the frontmatter language!** In the near future Zine will develop tooling for editing ziggy-markdown files. In the meantime consider downloading the Ziggy CLI tool for a smoother editing experience if you plan to use Ziggy directly.
- Added an initial version of sections to Zine! See the updated documentation section for more information about that. Beware that `$site.pages()` was removed in favor of the new system.
- Added a the ability to define `alternatives` in the frontmatter of a page. Alternatives allow you to specify multiple layouts to apply to the same piece of content. Useful for generating RSS feeds.
- Added syntax highlighting to layouts: now strings have a `syntaxHighlight` builtin. 
- Updated Zig version because [a bugfix](https://github.com/ziglang/zig/pull/19224) was needed to add syntax highlighting to templates. Now Zine depends on Zig `0.12.0-dev.3381+7057bffc1` and above. Make sure to update your GitHub Actions workflows accordingly.


### 2024-03-08 

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine.git#4b3efd178cb6ee9af3c864fa980ad0499823aac6",
.hash = "1220f6920dbb9540cc9013bbaa1621d62ef79aabadcbb6f7b9f45e415de815d15404",
```
- Added syntax highlighting support via tree-sitter. Most code snippets of this website have now gained syntax highlighting. No themes are provided for now and it's expected that you define your own CSS from scratch. See `hightlight.css` from this website for an idea on how to proceed.
- Updated Zig version because of a recent breaking change related to `std.http`. Now Zine depends on Zig `0.12.0-dev.3161+377ecc6af` and above. Make sure to update your GitHub Actions workflows accordingly.

### 2024-02-13
- Overhauled the documentation page. Now  it's a little bit easier to get started with Zine.
- Added deployment guides: [one for GitHub Pages](/documentation/deploying/github-pages/) and [one for Cloudflare Pages](/documentation/deploying/cloudflare-pages/) (thanks `ninja_tron`!)
- Started work on the JSON replacement for better frontmatters, [join the Discord server](https://discord.gg/B73sGxF) or [catch me live on Twitch](https://twitch.tv/kristoff_it) for related discussion & sneak peeks.

### 2024-02-11 

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine.git#beb5434a04fad660ecf8db8379532dfe5b5e13b0",
.hash = "12203c37cb5fb3931d3b7d1f1dace46cf5329ffe2fb5a8d2ac87dc78630ce7f601a7",
```
- Updated Zig version because of a recent breaking change related to `std.Options` / `root.std_options`. Now Zine depends on Zig `0.12.0-dev.2701+d18f52197` and above. Consider using [marler8997/zigup](https://github.com/marler8997/zigup) if you're not building Zig from source.
- The Scripty reference documentation was improved slightly: the reference for `Page` displays which fields have default values and which do not.
- The dev server is now better at reporting build errors: in the event of a build error the message will be shown in the terminal, as well as being shown on the web page, and the 404 page too will connect to the hot-reloading mechanism in order to show build errors.

### 2024-02-09 (later in the day)

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine.git#da7c32c2c253f6b0dbd392006055598feb07410b",
.hash = "1220e6580fdbd0a56a97300bab938f61fe3b5b35fc7755a150db267422cf554ab299",
```
- When running the dev server (`zig build serve`), Zine will now show build error messages inside of the web page itself using the hot reload mechanism. Fix the build error and the error overlay will disappear. Error messages are ugly for now  ([#16](https://github.com/kristoff-it/zine/issues/16)).


### 2024-02-09 

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine.git#527762348ef104dce601f52bca9f958a511ff11b",
.hash = "122018fb2b0ba1479ae28bacf3839d38da69044b006068fd67b1b7f4425114bec8d1",
```

- Zine will now stop erroring out in the presence of empty markdown files. It will instead print a warning and ignore them. Now you can `touch` a bunch of files and fill them out as you make progress, without losing hot reloading in the meantime.

### 2024-02-08

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine.git#eaa23f2d3a80868251302a1b979dbcc7e5b81d3a",
.hash = "1220230f7c6abf655ef9b1ec14161bd1c15e55afd14ceaedfe2e0e9cc2471b1dd0ca",
```
- Removed the `_index.md` vs `index.md` naming convention. Now it's always `index.md` and you can use the `skip_subdirs` frontmatter property to get the old behavior. See the docs for more information.
