---
{
    .title = "Changelog",
    .date = @date("2020-07-06T00:00:00"),
    .author = "Sample Author",
    .draft = false,
    .layout = "page.html",
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
</style>
<script>
window.onload = function() {
  document.querySelectorAll("button").forEach(function (b) {b.addEventListener("click", function () {
      navigator.clipboard.writeText(b.parentElement.nextElementSibling.textContent);
    });
  });
}
</script>


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
- Fixed a crash in the dev server that would trigger when refreshing the page multiple times in quick succession (the crash was realted to websockets). There's still one remaining known bug related to this same problem though.
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
- The dev server is now better at reporting build errors: in the event of a build error the message will be shown in the terminal, as well as being shown on the web page, and the 404 page too will connect to the hotreloading mechanism in order to show build errors.

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
