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
### 2024-01-09 (later in the day)

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine.git#da7c32c2c253f6b0dbd392006055598feb07410b",
.hash = "1220e6580fdbd0a56a97300bab938f61fe3b5b35fc7755a150db267422cf554ab299",
```
- When running the dev server (`zig build serve`), Zine will now show build error messages inside of the web page itself using the hot reload mechanism. Fix the build error and the error overlay will disappear. Error messages are ugly for now  ([#16](https://github.com/kristoff-it/zine/issues/16)).


### 2024-01-09 

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine.git#527762348ef104dce601f52bca9f958a511ff11b",
.hash = "122018fb2b0ba1479ae28bacf3839d38da69044b006068fd67b1b7f4425114bec8d1",
```

- Zine will now stop erroring out in the presence of empty markdown files. It will instead print a warning and ignore them. Now you can `touch` a bunch of files and fill them out as you make progress, without losing hot reloading in the meantime.

### 2024-01-08

<button>copy</button>
```zig
.url = "git+https://github.com/kristoff-it/zine.git#eaa23f2d3a80868251302a1b979dbcc7e5b81d3a",
.hash = "1220230f7c6abf655ef9b1ec14161bd1c15e55afd14ceaedfe2e0e9cc2471b1dd0ca",
```
- Removed the `_index.md` vs `index.md` naming convention. Now it's always `index.md` and you can use the `skip_subdirs` frontmatter property to get the old behavior. See the docs for more information.
