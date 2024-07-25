---
.title = "Quickstart",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "page.shtml",
.tags = [],
--- 

## Warning
Zine is currently alpha software and many features are missing or not complete yet.

**It's recommended to try Zine on a small project first to get a feeling of the limits of the current implementation.**

If Zine turns out to not be ready yet for your needs, check the [Changelog](/log/) from time to time to learn of new improvements.


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
$ zig build serve -Dport=8080
```
After that, start hacking on it and see how Zine reacts!


## 3. Get developer tooling
This step is optional but **strongly** recommended.


### Language Server
Get [SuperHTML](https://github.com/kristoff-it/superhtml) and configure your editor to use it for diagnostics and format-on-save.

![](superhtml.png)

SuperHTML also implements pretty sweet autoformatting (see the repo's README for more info):

<video controls autoplay loop disablepictureinpicture muted width=100%>
 <source src="/vscode-autoformatting.mp4">
</video>

#### VSCode
Get the [SuperHTML VSCode Extension](https://marketplace.visualstudio.com/items?itemName=LorisCro.super) (until [#8](https://github.com/kristoff-it/superhtml/issues/8) is implemented you will also need to download the SuperHTML CLI tool).

The extension will also give you syntax highlighting support for `.shtml` files (SuperHTML templates).

### Syntax Highlighting
SuperHTML template files have a `.shtml` extension. Since it's valid HTML, you can use normal syntax highlighting, but there are dedicated grammars that can help you understand your templates more easily at a glance.

In the SuperHTML repository you will also find a tree-sitter grammar which can be used  by Vim, NeoVim, Helix, etc.

## Next Steps
To learn more about Zine, [see the documentation section](/documentation/).

See the [Vision & Community section](/community/) to join our community.



