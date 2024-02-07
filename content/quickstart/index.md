---
{
  "title": "Quickstart",
  "date": "2020-07-06T00:00:00",
  "author": "Sample Author",
  "draft": false,
  "layout": "page.html",
  "tags": []
}  
--- 

## 1. Get Zig
Zine has only one dependency: the Zig compiler.

We currently track Zig's master branch so you will need to get an unstable build  from [the official website](https://ziglang.org).
In the future Zine will pin to a tagged release of Zig, be it an official release [or not](https://devlog.hexops.com/2024/announcing-nominated-zig/).


## 2. Clone Zine's Sample Site
After that, the easiest way of getting started is by cloing a sample website and start hacking on it.

***`shell`***
```sh
$ git clone https://github.com/kristoff-it/zine-sample-site.git
$ cd zine-sample-site
$ zig build serve -Dport=8080
```
## Next Steps

To learn more about Zine, [see the documentation section](/documentation/).

See the [Vision & Community section](/community/) to join our community.



