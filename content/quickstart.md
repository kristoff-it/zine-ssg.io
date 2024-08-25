---
.title = "Quickstart",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "page.shtml",
.tags = [],
--- 

>[Warning]($box.attrs('warning'))
>Zine is currently alpha software and many features are missing or not 
>complete yet.


## 1. Get Zig
Zine has only one dependency: the Zig compiler.

We currently track Zig's latest tagged release (0.13.0 at the moment).

You can download it from from [the official website](https://ziglang.org) or use [zigup](https://github.com/marler8997/zigup).

## 2. Clone Zine's Sample Site

And what's a better sample site than the official site itself?

***`shell`***
```bash
$ git clone https://github.com/kristoff-it/zine-ssg.io.git
$ cd zine-ssg.io
$ zig build serve
```
After that, start hacking on it and see how Zine reacts!

Here are a couple of things that you might want to observe:
- On first invocation it will take a moment for Zine to load, as it has to compile optimized versions of all its tools. Subsequent runs will be much faster.
- `zig build serve` launches the development server but you can also just generate the site without it. Run `zig build --summary new` to build the website and see which pages ended up being re-rendered. Notice how pages that don't change don't need to be re-rendered.
- What happens if you delete `assets/style.css` and try to rebuild the site?


## 3. Get developer tooling
This step is optional but **strongly** recommended.


### Language Server
Get [SuperHTML](https://github.com/kristoff-it/superhtml) and configure your editor to use it for diagnostics and format-on-save.

[]($image.siteAsset('superhtml.png').attrs("big"))

SuperHTML also implements pretty sweet autoformatting (see the repo's README for more info).

[]($video.siteAsset('vscode-autoformatting.mp4').attrs("big").loop(true).controls(true).muted(true).pip(false).autoplay(true))


#### VSCode
Get the [SuperHTML VSCode Extension](https://marketplace.visualstudio.com/items?itemName=LorisCro.super) (until [#8](https://github.com/kristoff-it/superhtml/issues/8) is implemented you will also need to download the SuperHTML CLI tool).

The extension will also give you syntax highlighting support for `.shtml` files (SuperHTML templates).

### Syntax Highlighting
SuperHTML template files have a `.shtml` extension. Since it's valid HTML, you can use normal syntax highlighting, but there are dedicated grammars that can help you understand your templates more easily at a glance.

In the SuperHTML repository you will also find a tree-sitter grammar which can be used  by Vim, NeoVim, Helix, etc.

## Next Steps
To learn more about Zine, [see the documentation section](/documentation/).

See the [Vision & Community section](/community/) to join our community.



