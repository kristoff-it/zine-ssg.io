---
{
    .title = "Home",
    .date = @date("2020-07-06T00:00:00"),
    .author = "Loris Cro",
    .draft = false,
    .layout = "index.html",
    .tags = [],
}  
--- 

# What is Zine?
A Zine site is a collection of markdown files, HTML templates and static assets. Zine turns your markdown content into HTML, styles it using your templates, and finally copies the result alongside your static assets into an output directory that you can then publish on static hosting services like GitHub Pages.

Zine is "low-code" by default, but once the needs of your project grow, then you will have the full power of the Zig build system at your disposal, allowing you to integrate any kind of pre-processing pipeline.

# Feature Highlights 
## The Power Of A Real Build System
Zine is a collection of tools (markdown renderer, templating engine, etc) orchestrated by the Zig build system. 

The Zig build system performs **surgical dependency tracking and automatic parallelization of the build**, making Zine very fast and scalable.

Since Zine tools cooperate via the build system, **each tool can be swapped out** for an alternative implementation provided by you. The Zig build system can also download and compile tools written in C/C++/Zig, so **you can easily depend on open source tools**.

If your site depends on any kind of build pipeline, like asset pre-processing, it's simple to add it to your Zig build pipeline.

## HTML Errors Are Build Errors
Zine uses Super, a templating language that extends HTML, instead of the usual `{{ curly brace }}` languages.
 
With Super it becomes impossible to output malformed HTML as the result of templating logic, and it also catches syntax errors at build time!

`page.html`
```html
<h1>Oops!<h1>
```

***`shell`***
```
$ zig build

---------- ELEMENT MISSING CLOSING TAG ----------
While it is technically correct in HTML to have a non-void element 
that doesn't have a closing tag, it's much more probable for
it to be a programming error than to be intended. For this
reason, this is a syntax error.

[closing_tag_missing]
(page.html) zine-sample-site/layouts/page.html:19:5:
    <h1>Oops!<h1>
     ^^
trace:
    layout `page.html`,
    content `_index.md`.
```


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


## ...and more
Zine is a very young project and many important features are yet to be implemented.

[Drop us a star on GitHub](https://github.com/kristoff-it/zine) in the meantime :^)

To gauge the level of maturity of Zine you might want to check [the changelog](/log/) on occasion.
