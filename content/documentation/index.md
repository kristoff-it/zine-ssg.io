---
.title = "Documentation",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "documentation.html",
.tags = [],
--- 
## Warning
Zine is currently alpha software. 

Many features are missing and currently Zine is only capable of building relatively simple websites. 

All the common features (like i18n, an asset system, etc) are planned, but will take some time to be implemented.

Using Zine today means participating in its development process.

## Other Pages
- [Multilingual Websites (i18n)](i18n/)
- [Scripty Reference](scripty/)
- Deploying
    - [GitHub Pages](deploying/github-pages/)
    - [Cloudflare Pages](deploying/cloudflare-pages/)

## Requirements
Zine is a collection of tools orchestrated by the Zig build system.

Zine only depends on the Zig compiler, see [the official website](https://ziglang.org) for more information on how to download and install Zig.

## Project Setup
Your website only needs the following two files to get started:

***build.zig.zon***
```zig
.{
    .name = "sample website",
    .version = "0.0.0",
    .dependencies = .{
        .zine = .{
            .url = "git+https://github.com/kristoff-it/zine#e33a1d79b09e8532db60347a7ec4bd3413888977",
            .hash = "12209f9be74fcc805c0f086e4a81ccca041354448f5b3592e04b6a6d1b4a95da5a26",
        },
    },
    .paths = .{"."},
}
```

***build.zig***
```zig
const std = @import("std");
const zine = @import("zine");

pub fn build(b: *std.Build) !void {
    try zine.addWebsite(b, .{
        .title = "Sample Website",
        .host_url = "https://sample.com",
        .layouts_dir_path = "layouts",
        .content_dir_path = "content",
        .static_dir_path = "static",
    });
}  
```

Once you create the 3 directories mentioned in your `build.zig` file (`layouts`, `content`, `static`, but they can also be named however you like), you are ready to start working on your website.

### Content
The content directory contains your markdown files and their structure will be 
reflected verbatim in the final site.

- `content/index.md` is the main index page of your website (ie `https://samplesite.com/`).
- `content/about.md` will generate `/about/index.html` (ie `https://samplesite.com/about/`).
- `content/foo/index.md` will generate `/foo/index.html` (ie `https://samplesite.com/foo/`).
- `content/foo/bar.md` will generate `/foo/bar/index.html` (ie `https://samplesite.com/foo/bar/`).

Note that SSGs rely heavily on the implication that webservers will 
automatically serve `index.html` when a directory (usually indicated by a final 
`/` in the URL) is requested. Most static servers will automatically redirect 
in the absence of a final slash (the Zine dev server does too), but by making
sure to include the final slash in your `<a>` elements you will spare your clients
one redirect round trip.

In the future Zine might make links with a missing final `/` a build error.

### Sections
Consider the following content structure:
```
content
├── about
│   └── contacts.md
├── about.md
├── blog
│   ├── a.md
│   ├── b.md
│   └── index.md
└── index.md
```
**In Zine every `index.md` file denotes a section.**

In this example there are 2 sections: 

The first one is the "root" section, defined by `content/index.md`, containing:

- `about/contacts.md`
- `about.md`
- `blog/index.md`

The second section is the "blog" section, defined by `content/blog/index.md`, containing:

- `blog/a.md`
- `blog/b.md`

Note how an `index.md` file defines a section but as a page it is not included in the list of pages that belong to that section.

Lastly, note how pages in a section don't all share the same basepath. In the absence of a nested `index.md`, all pages are considered siblings regardless of how they are nested inside of different directories.


#### Frontmatter
Each markdown file has a Ziggy frontmatter delimited by `---`. 

Ziggy is a data serialization language developed alongside Zine. You can learn more on the official Ziggy website: [https://ziggy-lang.io](https://ziggy-lang.io).

It is highly recommended to setup your editor with Ziggy support and to download
the Ziggy CLI tool. Unfortunately this won't grant you syntax highlighting for the
frontmatter section of your content files (although it will inside of code blocks).

Zine will eventually have its own LSP and related tooling for a fully smooth 
development experience.

***`index.md`*** 
```ziggy
---
.title = "Homepage",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "homepage.html",
.tags = [],
--- 
Your **markdown** content goes here.
```

Some fields, like `title`, and `layout` are mandatory, while others have default values.
See the Scripty reference relative to `Page` for more information. 

A very important required field is `layout`. This field must point at the layout
that you want to use to style your content. In Zine this field must always be 
explicitly filled out and there is no implicit convention system (like in Hugo, for example).

### Layouts
The layouts directory contains the html layouts that
will be applied to your content. We're going see how layouts work later in this document.

### Static
The contents of the static directory will be copied verbatim into the output directory.


# CLI
#### `$ zig build`
Builds your website and places it in `zig-out`. Pass `-p some/path/` to change the output directory.

Use `zig build --help` for more information about flags supported by `zig build`.

#### `$ zig build serve`
Builds your website and starts the development server. Making changes to any of your input directories (ie content, layouts, static) will automatically trigger a rebuild and a page reload.

Pass `-Dport=8080` to set the listening port to 8080.

# Layouting
In Zine layouts live under the `layouts/` directory.

Here's a basic example where we create the homepage of our sample website. 

***`content/index.md`*** 
```
---
.title = "Home",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "homepage.html",
.tags = [],
--- 
Hello World!
```

***`layouts/homepage.html`***
```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title var="$site.title"></title>
  </head>
  <body>
    <h1 var="$page.title"></h1>
    <div var="$page.content"></div>
  </body>
</html>
```


***`zig-out/index.html`*** (output)
```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Sample Site</title>
  </head>
  <body>
    <h1>Home</h1>
    <div><p>Hello World!</p></div>
  </body>
</html>
```

In this example we just saw:
- `index.md` defines in the frontmatter that its layout is `homepage.html`
- `homepage.html` defines some html and uses special attributes to pull in the contents of `index.md` (more on that later)
- the final output is going to be the homepage of our website 

If you run the dev server now (`zig build serve -Dport=8080`), you should see the output page at `https://localhost:8080/`.

### Adding more pages

Let's imagine now that we want to add a blog section to our website with a first post in it.

***`shell`***
```bash
$ mkdir content/blog
$ touch content/blog/first-post.md
$ touch layouts/post.html
```

***`content/blog/first-post.md`*** 
```
---
.title = "First Post!",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "post.html",
.tags = [],
--- 
This is my first post!
```

***`layouts/post.html`***
```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title var="$site.title"></title>
  </head>
  <body>
    <h1>Blog</h1>
    <h2 var="$page.title"></h2>
    <h3>by <span var="$page.author"></span></h3>
    <h4>Posted on: <span var="$page.date.format('January 02, 2006')"></span></h4>
    <div var="$page.content"></div>
  </body>
</html>
```

At this point you should be able to navigate to `http://localhost:8080/blog/first-post/` and see the result.

Note how we now need a new layout (`post.html`) since the blog post is not going to have the same structure at the homepage. 

While the structure is indeed different, both `post.html` and `homepage.html` share a lot of common boilerplate that would be nice not to have to maintain separately.

What we need now is a way to have both layouts put the common boilerplate into a singular *template* that then gets *extended* by each layout to produce two final different layouts.


## Extending templates

First, some terminology:

- **`layout`**: HTML file that can be directly used to style a piece of content. Layouts live directly under `layouts/`.
- **`template`**: HTML file that collects common boilerplate that contains extension points. Cannot be used directly to style content (as some parts need to be filled out) and must live under `layouts/templates/`.
- a **`layout`** can *extend* a **`template`** (but not viceversa).

Let's continue the example from the previous section where we try to collect all common boilerplate from `homepage.html` and `page.html`.

***`layouts/templates/base.html`***
```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title id="title"><super/></title>
  </head>
  <body id="main">
    <super/>
  </body>
</html>
```

***`layouts/homepage.html`***
```html
<extend template="base.html"/>

<title id="title" var="$site.title"></title>

<body id="main">
  <h1 var="$page.title"></h1>
  <div var="$page.content"></div>
</body>
```

***`layouts/post.html`***
```html
<extend template="base.html"/>

<title id="title" var="$site.title"></title>

<body id="main">
  <h1>Blog</h1>
  <h2 var="$page.title"></h2>
  <h3>by <span var="$page.author"></span></h3>
  <h4>Posted on: <span var="$page.date.format('January 02, 2006')"></span></h4>
  <div var="$page.content"></div>
</body>
```

Let's analyze what we just saw:

- `layouts/templates/base.html` now contains all the main HTML boilerplate and has two `<super/>` tags: one inside `<title>` and one inside `<body>` (both of which have also gained an `id` attribute).

- both layouts now start with an `<extend/>` tag and have lost their original structure (since it was collected in `base.html`), keeping only the parts that each defines differently than the other.

### `<extend/>`
When a layout wants to extend a template, it must declare at the very top the template name using the extend tag, like so: 

```html
<extend template="foo.html"/>
```

A layout that extends a template won't have a normal HTML structure, but rather it will be a list of HTML elements that will replace a correspoding super tag from the base template they're extending.

### `<super/>`
The super tag defines an extension point in a template. The direct parent of a super tag must have an `id` attribute.

**Each top level element in a layout must correspond to a super tag in the template being extended.**

Since super tags don't have any id of their own, **the layout uses the tag and `id` of the parent element of each super tag to match its content with the correct super tag**.

***template***
```html
<title id="title"><super/> - Sample Site</title>
```

***layout***
```html
<title id="title">Home</title>
```

***evaluates to***
```html
<title id="title">Home - Sample Site</title>
```

#### Why not just give `id`s to super tags?

Matching via parent elements is admittedly an uncommon choice, but it has some very real upsides over the alternatives.

Let's define a block in a curly brace templating language (mustache,jinja, hugo, etc):

***hugo***
```html
{{ define "main" }}
  <p> Hello World </p>
{{ end }}
```

This is the equivalent of a top-level element in a Zine layout that extends a template, but it has a critical disadvantage: **you know nothing about where the content will be put**.

Unless you have perfect recollection of what "main" is, you won't know if your content should be framed in a container element or not. In fact, all the following declarations in a hugo base template are possible:

***ok***
```html
<!DOCTYPE html>
<html>
  <head></head>
  <body>
    {{ block "main" . }}{{ end }}
  </body>
</html>
```
***oops, needed a `<body>` wrapper***
```html
<!DOCTYPE html>
<html>
    <head></head>
    {{ block "main" . }}{{ end }}
</html>
```
***oops, too many wrappers***
```html
<!DOCTYPE html>
<html>
  <head></head>
  <body>
    <p>{{ block "main" . }}{{ end }}</p>
  </body>
</html>
```

Contrast this with our previous example:

***`layouts/homepage.html`***
```html
<extend template="base.html"/>

<title id="title" var="$site.title"></title>

<body id="main">
  <h1 var="$page.title"></h1>
  <div var="$page.content"></div>
</body>
```
By looking at the layout we know that we are putting content directly into the `body` element of the template we are extending.

In fact if we were to make a mistake and define "main" as a `div` element in our layout, we would get a compile error:

***shell***
```
$ zig build

---------- MISMATCHED BLOCK TAG ----------
The super template defines a block that has the wrong tag.
Both tags and ids must match in order to avoid confusion
about where the block contents are going to be placed in
the extended template.

note: super template block tag:
(post.html) layouts/post.html:19:2:
    <div id="main">
     ^^^

note: extended template block defined here:
(base.html) layouts/templates/base.html:16:4:
    <body id="main">
     ^^^^
trace:
    layout `post.html`,
    content `about.md`.
```

So, if we were to give `id`s to super tags, we would have to introduce another
fake html tag and we would end up with the same problem that curly brace templating 
languages have today.

***where would this go?***
```html
<content id="main">
  <p> Hello World </p>
</content>
```

Repeating the parent element is a form of ***typing*** for your templates, in 
a sense.

## Extension chains

In the previous section we saw how a layout can extend a template. We are now 
going to see how templates can extend other templates.

Let's update our terminology one last time. Since both layouts and templates can
extend other templates, we need a generic way of referring to the template that 
is extending and the one being extended:

- a ***super template*** is the template (or layout) that extends another template.
- an ***extended template*** is the template being extended.

A template can take on both roles at the same time when in the middle of an 
extension chain. 

***`layouts/templates/base.html`***
```html
<!DOCTYPE html>
<html>
  <head id="head">
    <meta charset="UTF-8">
    <title id="title"><super/> - My Blog</title>
    <super/>
  </head>
  <body id="body">
    <super/>
  </body>
</html>
```
***`layouts/templates/with-menu.html`***
```html
<extend template="base.html"/>

<title id="title"><super/></title>

<head id="head">
  <script>console.log("Hello World!");</script>
</head>

<!-- at the top level only comments 
     and block definitions are allowed -->
<body id="body">
    <nav>
        <a>Home</a>
        <a>About</a>
    </nav>
    <div id="content">
        <super/>
    </div>
</body>
```
***`layouts/page.html`***
```html
<extend template="with-menu.html"/>

<title id="title" var="$page.title"></title>

<div id="content" var="$page.content"></div>
```

Note how `with-menu.html` is both fulfilling the *interface* (ie the extension points) of `base.html` and at the same time it's creating new ones for another *super template* to fulfill in turn.

In this last example `page.html` is featuring Scripty, the scripting language used to refer to your content from templates.

## Logic
Template logic is based on two main variables: `$site` and `$page`, representing the global site configuration and the current page respectively.

Example markdown file:

***`content/foo/index.md`***
```markdown
---
.title = "My Post",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "post.html",
.tags = ["tag1", "tag2", "tag3"],
--- 
The content
```


#### `var`
Prints the contents of a Scripty variable.

***`layouts/post.html`***
```html
<span var="$page.title"></span>  
```

***`output`***
```html
<span>My Post</span>
```


#### `if`
Toggles the body of an element based on the condition.


***`layouts/post.html`***
```html
<div if="$page.title.len().eq(1)" id="foo">
    <b>Won't be rendered</b>
</div>  
```

***`output`***
```html
<div id="foo"></div>
```

#### `loop`
Repeats the body of an element based on the condition. Inside an element with a `loop` attribute, `$loop` becomes available.


***`layouts/post.html`***
```html
<ul loop="$page.tags" id="tags">
   <li var="$loop.it"></li>
</ul>  
```

***`output`***
```html
<ul id="tags">
   <li>tag1</li>
   <li>tag2</li>
   <li>tag3</li>
</ul>  
```

#### `inline-loop`
Repeats the **entire** element based on the condition. Inside an element with a `loop` attribute, `$loop` becomes available.

***`layouts/post.html`***
```html
<div inline-loop="$page.tags" var="$loop.it"></div>
```

***`output`***
```html
<div>tag1</div>
<div>tag2</div>
<div>tag3</div>
```

## Scripty Reference
To learn about all the types present in Scripty and their builtin operations, [see the full reference](scripty/).
