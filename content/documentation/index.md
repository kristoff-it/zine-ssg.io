---
.title = "Documentation",
.date = @date("2020-07-06T00:00:00"),
.author = "Sample Author",
.draft = false,
.layout = "documentation.shtml",
.tags = [],
--- 

## Warning
Zine is currently alpha software and many features are missing or not complete yet.

**It's recommended to try Zine on a small project first to get a feeling of the limits of the current implementation.**

If Zine turns out to not be ready yet for your needs, check the [Changelog](/log/) from time to time to learn of new improvements.

## Other Pages
- [Multilingual Websites (i18n)](i18n/)
- [Scripty Reference](scripty/)
- Deploying
    - [GitHub Pages](deploying/github-pages/)
    - [Cloudflare Pages](deploying/cloudflare-pages/)

## Requirements
Zine is a collection of tools orchestrated by the Zig build system.

Zine only depends on the Zig compiler, follow [the quickstart guide](/quickstart) to learn how to setup Zig and other optional developer tooling.

## Project Setup
Your website only needs the following two files to get started:

***build.zig.zon***
```zig
.{
    .name = "sample website",
    .version = "0.0.0",
    .dependencies = .{
            .url = "git+https://github.com/kristoff-it/zine#v0.1.0",
            .hash = "1220e9f603ff14b5ec69442f0287588ad20072d836b05b3a7e4100dd30e95fef1cd3",
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
        .content_dir_path = "content",
        .layouts_dir_path = "layouts",
        .static_dir_path = "static",
    });
}  
```

Once you create the 3 directories mentioned in your `build.zig` file (`content`, `layouts`, `static`, but they can also be named however you like), you are ready to start working on your website.

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

#### Sections
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
Layouts are used to style your content files. 

Here's a schema that shows the processing pipeline. Square brackets indicate an artifact, while round parens indicate a tool orchestrated by Zine.
```
[content/foo.md]
  => (markdown-renderer)
    => [foo.md.html]
      => (layout-engine) + [layouts/page.shtml]
        => [foo/index.html]
```

Later in this document we'll see how layouts work more in detail.

### Static
The contents of the static directory will be copied verbatim into the output directory.


# CLI
#### `$ zig build`
Builds your website and places it in `zig-out`. Pass `-p some/path/` to change the output directory.

Use `zig build --help` for more information about flags supported by `zig build`.

#### `$ zig build serve`
Builds your website and starts the development server. Making changes to any of your input directories (ie content, layouts, static) will automatically trigger a rebuild and a page reload.

Pass **`-Dport=8080`** to set the listening port to 8080.

# Layouting
Zine uses [SuperHTML](https://github.com/kristoff-it/superhtml) as its templating language. 

SuperHTML templates have a `.shtml` file extension and can describe static "extension hierarchies" that span multiple files alongside branching and looping logic.

Most templating languages of this kind use `{{ curly braces }}` and act as a form of pre-processor that has close to no understanding of HTML.

SuperHTML is instead a super-set of HTML. 


## Layout vs Template
Throughout this document (and in error messages) you will see a distinction being made between 'layouts' and 'templates'.

In Zine a layout is a template that can be fully evaluated to a complete HTML file that has no "extension placeholders" left.

We'll see in a bit how templates extend each other by defining "placeholders" that can be then filled out by another template. Layouts are basically the final link of a "chain" of templates that extend one another.

The special name for those templates is used because, unike other templates, they define a final, complete layout for a set of pages.

## Basic Example

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

***`layouts/homepage.shtml`***
```superhtml
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
- `index.md` defines in the frontmatter that its layout is `homepage.shtml`
- `homepage.shtml` defines some HTML and uses special attributes to pull in the contents of `index.md` (more on that later)
- the final output is going to be the homepage of our website 

If you run the dev server now (`zig build serve -Dport=8080`), you should see the output page at `https://localhost:8080/`.

### Adding more pages

Let's imagine now that we want to add a blog section to our website with a first post in it.

***`shell`***
```bash
$ mkdir content/blog
$ touch content/blog/first-post.md
$ touch layouts/post.shtml
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

***`layouts/post.shtml`***
```superhtml
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

Note how we now need a new layout (`post.shtml`) since the blog post is not going to have the same structure at the homepage. 

While the structure is indeed different, both `post.shtml` and `homepage.shtml` share a lot of common boilerplate that would be nice not to have to maintain separately.

What we need now is a way to have both layouts put the common boilerplate into a singular *template* that then gets *extended* to produce two final different pages.


## Extending templates

Let's continue the example from the previous section where we try to collect all common boilerplate from `homepage.html` and `page.html`.

***`layouts/templates/base.shtml`***
```superhtml
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title id="title"><super></title>
  </head>
  <body id="main">
    <super>
  </body>
</html>
```

***`layouts/homepage.shtml`***
```superhtml
<extend template="base.html">

<title id="title" var="$site.title"></title>

<body id="main">
  <h1 var="$page.title"></h1>
  <div var="$page.content"></div>
</body>
```

***`layouts/post.shtml`***
```superhtml
<extend template="base.html">

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

- `layouts/templates/base.shtml` now contains all the main HTML boilerplate and has two `<super>` tags: one inside `<title>` and one inside `<body>` (both of which have also gained an `id` attribute).

- both layouts now start with an `<extend>` tag and have lost their original structure (since it was collected in `base.html`), keeping only the parts that each defines differently than the other.

### `<extend>`
When a layout wants to extend a template, it must declare at the very top the template name using the extend tag, like so: 

```superhtml
<extend template="foo.html">
```
A template that extends another won't have a normal HTML structure, but rather it will be a list of HTML elements that will replace a correspoding super tag from the base template they're extending.

### `<super>`
The super tag defines an extension point in a template. The direct parent of a super tag must have an `id` attribute.

**Each top level element in a template that extends another must correspond to a super tag in the template being extended.**

Let's call the "template that extends another" the **super template** (imagine that placing `<super>` in the code is like calling a *super template* for help).

Since super tags don't have any id of their own, **the *super template* uses the same tag and `id` of the parent element of each super tag to match its content with the correct super tag**.

***template***
```superhtml
<title id="title"><super> - Sample Site</title>
```

***layout***
```superhtml
<title id="title">Home</title>
```

***evaluates to***
```html
<title id="title">Home - Sample Site</title>
```

#### Why not just give `id`s to super tags?

Matching via parent elements is admittedly an uncommon choice, but it has some very real upsides over the alternatives.

Let's define a block in a curly brace templating language (mustache, jinja, hugo, etc):

***hugo***
```html
{{ define "main" }}
  <p> Hello World </p>
{{ end }}
```

This is the equivalent of a top-level element in a Zine template that extends another template, but it has a critical disadvantage: **you know nothing about where the content will be put**.

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
By looking at the *super template* we know that we are putting content directly into the `body` element of the template we are extending.

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

In the previous section we saw how a template can extend another. We are now 
going to see how longer extension chains look like.

At this point it's also useful to think of templates as documents that can do two things:

- Define an interface by using `<super>`.
- Fulfill an interface by extending another template and definig top-level elements that match corresponding blocks in the template they extend.

Let's see an example: 

***`layouts/templates/base.shtml`***
```superhtml
<!DOCTYPE html>
<html>
  <head id="head">
    <meta charset="UTF-8">
    <title id="title"><super> - My Blog</title>
    <super>
  </head>
  <body id="body">
    <super>
  </body>
</html>
```
***`layouts/templates/with-menu.shtml`***
```superhtml
<extend template="base.html">

<title id="title"><super></title>

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
        <super>
    </div>
</body>
```
***`layouts/page.shtml`***
```superhtml
<extend template="with-menu.html">

<title id="title" var="$page.title"></title>

<div id="content" var="$page.content"></div>
```

Note how `with-menu.shtml` is both fulfilling the *interface* (ie the extension points) of `base.shtml` and at the same time it's creating new ones for another *super template* to fulfill in turn.


Let's see now how attributes like `var` work.

## SuperHTML Template Logic

SuperHTML templates implement logic via special attributes that have semantic meaning for the templating language. The values given to those attributes are [Scripty](https://github.com/kristoff-it/scripty) expressions.

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
Toggles the body of an element based on a condition.


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
Repeats the body of an element based on a condition. Inside an element with a `loop` attribute, `$loop` becomes available.


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
Repeats the **entire** element based on a condition. Inside an element with a `inline-loop` attribute, `$loop` becomes available.

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
