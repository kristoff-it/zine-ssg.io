---
.title = "Home",
.date = @date("2020-07-06T00:00:00"),
.author = "Loris Cro",
.draft = false,
.layout = "index.shtml",
.tags = [],
---

>[Warning]($box.attrs('warning'))
>Zine is alpha software.  
>Using Zine today means participating in its development.

## What is Zine?
A Zine site is a collection of markdown content files and HTML templates.
Zine turns your markdown content into HTML, styles it using your templates, and
finally copies the result (alongside other assets like images) into an output directory
that you can then publish on static hosting services like GitHub Pages.

Zine uses a **structured approach to content authoring** that helps keeping sizeable
content collections manageable. Similarly, the build process uses **surgical
dependency tracking** to ensure minimal rebuilds, keeping the authoring experience
excellent at all scales.

*Zine is pronounced like in [fan**zine**](https://en.wikipedia.org/wiki/Zine)*.
    
## A handcrafted authoring experience
Zine uses [SuperMD]($link.page('docs/supermd')) for content and [SuperHTML]($link.page('docs/superhtml')) for defining layouts. Both languages were developed 
alongside Zine and are **desinged to push forward the state of the art** when it
comes to authoring static content.

SuperMD is an extension of Markdown that allows you to **define embedded assets 
and semantic constructs that would be impossible to express in Markdown** without
using inline HTML.

SuperHTML is an extension of HTML5 that focuses on expressing **correct templating
logic**. With SuperHTML it's **impossible to generate malformed HTML** and most
mistakes become **build time errors**. 

[Learn more about file formats in Zine]($link.page('docs/scripty')).

## Dynamic as needed
Zine specializes in the generation of static content but integration with both dynamic frontend and backend technologies is straigthtforward.





## A delightful HTML experience 
Zine uses [SuperHTML](https://github.com/kristoff-it/superhtml), a templating language that extends HTML, instead of the usual `{{ curly brace }}` languages.

SuperHTML is also an HTML language server that gives you real-time feedback on
syntax errors in your code.


[]($image.siteAsset('superhtml.png').attrs("big"))

SuperHTML also provides autoformatting (with the [SuperHTML VScode extension](https://marketplace.visualstudio.com/items?itemName=LorisCro.super)):

[]($video.siteAsset('vscode-autoformatting.mp4').attrs("big").loop(true).controls(true).muted(true).pip(false).autoplay(true))

And even if you don't want to use the language server, HTML errors are build errors in Zine:



`page.html`
```html
<div id="foo" id="oops"></div>
```

***`shell`***
```
$ zig build

---------- DUPLICATE ATTRIBUTE ----------
HTML elements cannot contain duplicate attributes.

[duplicate_attr]
(page.html) zine-sample-site/layouts/page.html:19:18:
    <div id="foo" id="oops"></div>
                  ^^

node: previous instance was here:
(page.html) zine-sample-site/layouts/page.html:19:9:
    <div id="foo" id="oops"></div>
         ^^
trace:
    layout `page.html`,
    content `_index.md`.
```


## The Power Of A Real Build System
Zine is a collection of tools (markdown renderer, templating engine, etc) orchestrated by the Zig build system. 

The Zig build system performs **surgical dependency tracking and automatic parallelization of the build**, making Zine very fast and scalable.

Since Zine tools cooperate via the build system, **each tool can be swapped out** for an alternative implementation provided by you. The Zig build system can also download and compile tools written in C/C++/Zig, so **you can easily depend on open source tools**.

If your site depends on any kind of build pipeline, like asset pre-processing, it's simple to add it to your Zig build pipeline.

## ...and more
Zine is a very young project and many important features are yet to be implemented.

[Drop us a star on GitHub](https://github.com/kristoff-it/zine) in the meantime :^)

To gauge the level of maturity of Zine you might want to check [the changelog](/log/) on occasion.
