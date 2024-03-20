---
{
    .title = "Vision & Community",
    .date = @date("2020-07-06T00:00:00"),
    .author = "Sample Author",
    .draft = false,
    .layout = "page.html",
    .tags = [],
}  
--- 
## Vision
Hi, I'm Loris Cro, the creator of Zine.

I'm VP of Community at the [Zig Software Foundation](https://ziglang.org),
host of [Zig SHOWTIME](https://zig.show) and the curator of 
[Software You Can Love](https://softwareyoucan.love), a cycle of conferences 
that has run in Vancouver and [Milan](https://sycl.it). I also write on my 
personal blog at [https://kristoff.it](https://kristoff.it).

Each of the links in the previous section points to a static website authored 
by me. 

My journey in creating software (and other experiences) 
you can love has taught me that, if your project is serious enough, you will
need a website and that in most cases the best fit will be a *static* website.

For this reason I've become interested in streamlining the static website 
building experience for myself and others who are interested in creating *experiences*
you can love.

Zine is tailored for creators who want to make simple, elegant websites that 
reflect the attention to detail they already put in designing their main product.

Zine itself is designed according to this principle and this is why I've decided
to design the templating exeperience of Zine, instead of blindly assuming that
it would be impossible to create a solution that fits Zine better than existing
off-the-shelf templating languages.

## Other static site generators
My experience in working with static site generators can be succintly described
as using tools that sit at two extremes in the flexibility-rigidity spectrum.

### Flexibility
The most flexible SSGs that I've used are JavaScript frameworks, 
which give you the ability to customize the build process in any way you can 
imagine. 

The downside of this type of tool is that it will allow you to express things 
in ways that are absolutely hostile to caching, hindering the SSG's 
ability to perform caching and ultimately feeling responsive.

The first iteration of my personal blog was written with Gatsby, which I chose
at the time because I already knew JSX and didn't want to learn a new templating 
language. Unfortunately my blog would take literal minutes to build on a beefy 
MacBook Pro, and it completely broke after switching to a M1 MacBook Air.

This bad experience made me look for something more performant that would not 
break when changing dev environment, which led me to Hugo.

### Rigidity
Hugo was until very recently my main SSG. Single executable and fast. It does
have C dependencies if you want certain pre-processing features, but using Zig 
[I was able to cross-compile](https://dev.to/kristoff/zig-makes-go-cross-compilation-just-work-29ho) 
it without much fuss.

Unfortunately Hugo suffers from two main issues:

#### Templating language
The templating language, which builds upon Go's stdlib templating package, is bad.

As a first objective flaw, it's unable to do full dependency tracking when 
shortcodes are involved, meaning that the dev server won't perform hot reloading
on a change. This is an [open issue](https://github.com/gohugoio/hugo/issues/6177) 
since 2019, and I've personally also experienced false cache hits from Hugo when
hot reloading does trigger (!).

A second issue I have with the templating language is that it's just 
unnecessarily counter-intuitive to use. This is a subjective opinion but I claim 
that, even setting aside Go's templating language quirks, all curly brace 
templating languages are a suboptimal choice when templating HTML.

There is no point in letting users express this kind of logic:

```html
<a href="bar">
  {% if foo %}
    </a><a href="baz">
  {% end %}
</a>
```

In Zine malformed HTML is a build error thanks to the Super templating language
which operates on HTML semantically, instead of being a glorified macro system.

#### Customization
The second big issue I have with Hugo has to do with customization. The flipside
of being a single executable is that it's hard to customize its behavior when
you need to go off the beaten path.

For [https://ziglang.org](https://ziglang.org) I wanted to test all code 
snippets present on the site, which led me to fork Hugo to add that custom
functionality.

But even if you want something less extreme, you will be out of luck if it's not
something supported by Hugo. Want syntax highlighting for your code snippets? 
Unless it's [one of the languages supported by Hugo](https://gohugo.io/content-management/syntax-highlighting/#list-of-chroma-highlighting-languages), there's no simple solution.

With Hugo I had gained a faster and more portable SSG, but I had lost the ability
to customize the build process.

## A new sweet spot
With Zine I want to find a new sweet spot between speed, scalability and flexibility.


### Like hugo
Like Hugo, Zine has a "low-code" (as opposed to full-blown JSX) templating 
language and a fixed project structure, because it helps making your site 
more maintainable and easier to collaborate on, especially when non-programmers 
are involved.

To learn more about this perspective, see "[It's Not About the Technology](https://www.youtube.com/watch?v=89bLKVvF85M)" by Mason Remaley from Software You Can Love Vancouver 2023.
 
### Unlike hugo
Unlike Hugo, Zine is not a single executable but rather a collection of tools
orchestrated by the Zig build system. This means that we pay a small performance
price to go from in-process communication to file-based multiprocessing, but in
exchange each executable can be easily replaced with a custom implementation.

Since the Zig build system is also a package manager, replacing an executable
can be done in a self-contained and portable way, especially if written in Zig.

File-based communication has the upside that it lets us cache intermediate 
artifacts, which can compensate for the initial performance cost, alongside
the fact that Zig executables are inherently faster than Go.

### Unlike JavaScript SSGs
Customization has to be expressed through the build system so that scalability is not
compromised.


## Community
[Join my Discord server](https://discord.gg/B73sGxF) to talk about Zine and get 
help as an early adopter.

If you prefer forums, you can find me on [https://ziggit.dev](https://ziggit.dev).
