---
{
    .title = "Quickstart",
    .date = @date("2020-07-06T00:00:00"),
    .author = "Sample Author",
    .draft = false,
    .layout = "page.html",
    .tags = [],
} 
--- 
## Warning
Zine is currently alpha software. 

Many features are missing and currently Zine is only capable of building relatively simple websites. 

All the common features (like i18n, an asset system, etc) are planned, but will take some time to be implemented.

Using Zine today means participating in its development process.

## 1. Get Zig
Zine has only one dependency: the Zig compiler.

We currently track Zig's master branch so you will need to get an unstable build  from [the official website](https://ziglang.org).
In the future Zine will pin to a tagged release of Zig, be it an official release [or not](https://devlog.hexops.com/2024/announcing-nominated-zig/).


## 2. Clone Zine's Sample Site

And what's a better sample site than the official site itself?

***`shell`***
```bash
$ git clone https://github.com/kristoff-it/zine-ssg.io.git
$ cd zine-ssg.io
$ zig build serve -Dport=8080
```
After that, start hacking on it and see how Zine reacts!

## Next Steps

To learn more about Zine, [see the documentation section](/documentation/).

See the [Vision & Community section](/community/) to join our community.



