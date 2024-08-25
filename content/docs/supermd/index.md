---
.title = "SuperMD Basics",
.description = "",
.author = "Loris Cro",
.layout = "documentation.shtml",
.date = @date("2023-06-16T00:00:00"),
.draft = false,
---

## Intro

**Make sure to read [Scripty Basics]($link.page('docs/scripty')) first.**


SuperMD is an extension of Markdown that adds Scripty expression support.

There are [plenty](https://github.github.com/gfm/) [of](https://github.com/iamgio/quarkdown) Markdown dialects in the wild that add new syntax to it, and there are also [plenty](https://mdxjs.com/) [of](https://gohugo.io/content-management/shortcodes/) templating languages that allow you to *template* your Markdown content.

The problem with the first approach is that the new syntax complicates an already overcomplicated language (to parse) and it usually only solves very precise problems.

The problem with the second approach is that, while templating (like [Hugo Shortcodes](https://gohugo.io/content-management/shortcodes/)) does allow you to extend Markdown in a very general way, it usually translates into pulling layouting concerns into the content, which is the exact thing we were trying to minimize by writing Markdown in the first place.


### Two Columns
For example let's say that you would like to have the middle section of a page to have a two column layout, this is how you could solve it:

- In [CommonMark](https://commonmark.org/) (with inline HTML support enabled):
  ```markdown
  <div class="flex-row"><div>
    
  # Left side

  </div><div>

  # Right side

  </div></div>
  ```

- In [MDX](https://mdxjs.com) *(semi-jokingly)*:
  ```markdown
  import {
    Row, 
    Left, 
    Right
  } from '@leftpad-inc/two-columns';

  <Row>
    <Left>

    # Left Side
    
    </Left><Right>

    # Right Side

    </Right>
  </Row>
  ```  

- In Hugo (using [Shortcodes](https://gohugo.io/content-management/shortcodes/)):
  ```markdown
  {{< row >}}
    {{% div %}} 
    # Left Side 
    {{% /div %}}{{% div %}} 
    # Right Side 
    {{% /div %}}
  {{< /row >}}
  ```

SuperMD takes a completely different approach by allowing the templating language to access the content in *blocks*:

***`two-columns.smd`***
```markdown
# [Left Section]($block.id('left'))
Lorem Ipsum

# [Right Section]($block.id('right'))
Dolor Something Something
```

***`layout.shtml`***
```superhtml
<div class="flex-row">
  <div html="$page.block('left')"></div>
  <div html="$page.block('right')"></div>
</div>
```

### Design Goals
The main design goal of SuperMD is to upgrade Markdown to a full-fledged markup format that is not dependent on HTML anymore.

Markdown is [often times](https://buttondown.com/hillelwayne/archive/why-i-prefer-rst-to-markdown/) considered too simplistic for serious markup work (e.g. creating a book) in good part also because of its ties to HTML.

SuperMD doesn't allow inlined HTML and instead gives you the ability to define a variety of "embedded assets" through a unified syntax.

It is planned for Zine to eventually gain support for generating PDFs (and potentially other file formats), at which point it will be critical for the content markup language to have the ability to define embedded assets (and styling elements) without using HTML as a crutch.

#### Roadmap
Compared to other parts of Zine, SuperMD is very new and many parts of it are
still in their first design iteration. The name and general similarity to 
Markdown are set in stone for SuperMD, but actual CommonMark adherence is not
guaranteed.

All other file formats in Zine have a parser written from scratch, except 
SuperMD (which uses [cmark-gfm](https://github.com/kristoff-it/cmark-gfm)) and 
it might be that at some point we'll switch to a more sane (parsing-wise) 
language that still has the same general feeling of writing Markdown.


## File Extension
SuperMD files have a `.smd` file extension.

## [Frontmatter]($heading.id('frontmatter'))
As mentioned in the main documentation page, every SuperMD file in Zine must start with a frontmatter that contains all the metadata relative to the page.

SuperMD uses [Ziggy](https://ziggy-lang.io) as its frontmatter data serialization language.

This is the full Ziggy Schema for the frontmatter:

***frontmatter.ziggy-schema***
[]($code.buildAsset('frontmatter').language('ziggy-schema'))

The frontmatter data fill become available in SuperHTML inside of instances of 
[`Page`]($link.page('docs/superhtml/scripty').ref('Page')).

## Markdown Syntax
SuperMD uses [cmark-gfm](https://github.com/kristoff-it/cmark-gfm) so it supports all the common extensions (tables, strikethrough, autolinks, etc) that you can normally find in the wild.

Currently SuperMD adds only one new syntactical construct: **a Scripty expression embedded in link syntax**.

***`image example`*** 
```markdown
[]($image.asset('cat.jpg'))
```

In normal Markdown this example would result in a (invalid) link element.

In SuperMD the resulting type of that construct depends on the  value that the embedded Scripty expression evaluates to. 

In the previous example the expression evaluates to an 
[`Image`]($link.page('docs/supermd/scripty').ref('Image')), 
making it equivalent to the vanilla `![](cat.jpg)`.

This might not seem particularly exciting, but things become more interesting
once you realize that this way of doing things allows you to easily give `id`s
and other attributes to both emdedded assets and pieces of content.

***`image example`*** 
```markdown
[]($image.asset('cat.jpg').id('foo'))
```
***`rendered html`*** 
```html
<img id="foo" src="path/to/cat.jpg">
```

Additionally, it also gives you the ability to define embedded assets that are
not supported by Markdown without the help of HTML.

For example this how you can define a video embed:
```markdown
[]($video.asset('video.mp4').loop(true).autoplay(true))
```

What we described up until now as "emdedded assets", are called "rendering directives" in Zine. Most of them do describe embedded assets, but `$block` (as seen in the two columns example) for example does not.

## Directives

**NOTE:** Directives are a very recent addition to Zine and new ones will be added over time. Make sure to check this page and the Scripty reference whenever you update Zine.

Most Directives are very straight forward to use. The only thing to keep in
mind is that calling functions on them sets their internal state in a way that
is order-independent (some might call this a *builder pattern* or a *fluent
interface*).

For example both of these invocations will yield the same final result:
```markdown
[]($link.page('foo').id('bar'))
[]($link.id('bar').page('foo'))
```

One last thing to know about Directives is that all allow you to set `id()` and `attrs()` (shorthand for attributes), which will be rendered in HTML as and `id` and a `class` attribute respectively.

You can find the full list of available Directives in the [SuperMD Scripty Reference]($link.page('docs/supermd/scripty')).

### Block Directive

The block directive lets you split a page into *content blocks*.

Doing so has three main benefits: 

- Creates a container element that groups the block's inner elements, useful for styling purposes.

- (when given an id) The ability to deep-link content from other pages while also having the deep-linking be validated by Zine.

- (when given an id) The ability to optionally render the page block-by-block, which is critical when the layout needs nuanced control over the content (see the two columns example at the top of this page).


#### Usage

There are two main ways to use the block directive:

1. as a top-level element
2. as a wrapper around  the text of a *heading*

In both cases the block directive will create a container element that wraps all
subsequent markdown content until another Block Directive is found or the 
document ends.

***`example`***
```markdown
[]($block)
# First
Lorem Ipsum

# Second
[]($image.asset('cat.jpg'))

[]($block.id('third'))
## Third
```

***`rendered html`***
```html
<div>
  <h1>First</h1>
  <p>Lorem Ipsum</p>
  
  <h1>Second</h1>
  <img src="cat.jpg">
</div>

<div id="third">
  <h2>Third</h2>
</div>
```

The second method additionally makes the heading link to the block:

***`example`***
```markdown
# [First]($block.id('first'))
Lorem Ipsum
```

***`rendered html`***
```html
<div id="first">
  <h1><a href="#first">First</a></h1>
  <p>Lorem Ipsum</p>
</div>
```

This second way of defining blocks might trick you into thinking that heading 
levels are relevant in terms of sectioning, so it's important to keep in mind 
that **heading levels are not taken into consideration when defining blocks**.
In other words, blocks don't nest.

This second way of defining a Block directive can be seen as syntax sugar for:

```markdown
[]($block.id('first'))
# [First]($link.ref('first'))
Lorem Ipsum
```

#### Rendering content blocks
The previous examples showcased the result of rendering the page in its 
entirety, but blocks that are given an `id` can also be rendered in isolation.

When rendering a block in isolation you are expected to provide the container
element in your template.

***`example`***
```markdown
# [First]($block.id('first'))
Lorem Ipsum
```

***`superhtml`***
```html
<div id="first" :html="$page.block('first')"></div>
```

***`rendered html`***
```html
<div id="first">
  <h1><a href="#first">First</a></h1>
  <p>Lorem Ipsum</p>
</div>
```

## Inline HTML Escape Hatch

SuperMD forbids inline HTML in order to make it possible to render
content files to non-HTML formats. 

That said, sometimes one only plans to target HTML and would like
to be able to embed, say, a YouTube video without too much fuss.

For those cases, you can still inline HTML in a content page by creating
a `=html` code block, like so:

    ```=html
    <script>alert("Yep, it's inlined alright")</script>
    ```

Zine will parse and validate the code before inlining.

