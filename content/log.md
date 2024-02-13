---
{
  "title": "Changelog",
  "date": "2020-07-06T00:00:00",
  "author": "Sample Author",
  "draft": false,
  "layout": "page.html",
  "tags": []
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


### 2024-02-13
- Overhauled the documentation page. Now  it's a little bit easier to get started with Zine.
- Added deployment guides: [one for GitHub Pages](/documentation/deploying/cloudflare-pages/) and [one for Cloudflare Pages](/documentation/deploying/cloudflare-pages/) (thanks `ninja_tron`!)
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
