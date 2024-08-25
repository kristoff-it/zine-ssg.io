---
.title = "SuperMD Scripty Reference",
.description = "",
.author = "Loris Cro",
.layout = "scripty-reference.shtml",
.date = @date("2023-06-16T00:00:00"),
.draft = false,
---
# [Global Scope]($block.id('global'))

## `$block` : [Block]($link.ref("Block"))

A content block, used to define a portion of content
that can be rendered separately by a template. 

## `$heading` : [Heading]($link.ref("Heading"))

Allows giving an id and attributes to a heading element.

## `$image` : [Image]($link.ref("Image"))

An embedded image.

## `$video` : [Video]($link.ref("Video"))

An embedded video.

## `$link` : [Link]($link.ref("Link"))

A link.

## `$code` : [Code]($link.ref("Code"))

An embedded piece of code.

# [anydirective]($block.id('anydirective'))

Each directive's functions will allow you to set the directive's 
internal fields accordingly using a "builder pattern" / "fluent interface".

For example, in:

```markdown
[]($image.asset('cat.jpg').id('meow'))
```
The call to `asset` returns a reference to the original
`$image` directive, which in turn then gets modified a 
second time by `id`.

Different kinds of directives will have different functions 
but all will support the functions listed here.

## Functions

### []($heading.id("anydirective.id")) [`fn`]($link.ref("anydirective.id")) id (str) -> [anydirective]($link.ref("anydirective"))

Sets the unique identifier field of this directive.

### []($heading.id("anydirective.attrs")) [`fn`]($link.ref("anydirective.attrs")) attrs (str, [str...]) -> [anydirective]($link.ref("anydirective"))

Appends to the attributes field of this Directive.

# [Block]($block.id('Block'))

A content block, used to define a portion of content
that can be rendered separately by a template. 

## Functions

### []($heading.id("Block.end")) [`fn`]($link.ref("Block.end")) end (bool) -> [Block]($link.ref("Block"))

Calling this function makes this block directive 
terminate a previous block without opening a new
one.

An end block directive cannot have any other 
property set.

# [Heading]($block.id('Heading'))

Allows giving an id and attributes to a heading element.

# [Image]($block.id('Image'))

An embedded image.

## Functions

### []($heading.id("Image.alt")) [`fn`]($link.ref("Image.alt")) alt (str) -> [Image]($link.ref("Image"))

An alternative description for this image that accessibility
tooling can access.

### []($heading.id("Image.caption")) [`fn`]($link.ref("Image.caption")) caption (str) -> [Image]($link.ref("Image"))

A caption for this image.

### []($heading.id("Image.linked")) [`fn`]($link.ref("Image.linked")) linked (bool) -> [Image]($link.ref("Image"))

Wraps the image in a link to itself.

### []($heading.id("Image.url")) [`fn`]($link.ref("Image.url")) url (str) -> [Image]($link.ref("Image"))

Sets the source location of this directive to an external URL.

### []($heading.id("Image.asset")) [`fn`]($link.ref("Image.asset")) asset (str) -> [Image]($link.ref("Image"))

Sets the source location of this directive to a page asset.

### []($heading.id("Image.siteAsset")) [`fn`]($link.ref("Image.siteAsset")) siteAsset (str) -> [Image]($link.ref("Image"))

Sets the source location of this directive to a site asset.

### []($heading.id("Image.buildAsset")) [`fn`]($link.ref("Image.buildAsset")) buildAsset (str) -> [Image]($link.ref("Image"))

Sets the source location of this directive to a build asset.

# [Video]($block.id('Video'))

An embedded video.

## Functions

### []($heading.id("Video.loop")) [`fn`]($link.ref("Video.loop")) loop (bool) -> [Video]($link.ref("Video"))

If true, the video will seek back to the start upon reaching the 
end.

### []($heading.id("Video.muted")) [`fn`]($link.ref("Video.muted")) muted (bool) -> [Video]($link.ref("Video"))

If true, the video will be silenced at start. 

### []($heading.id("Video.autoplay")) [`fn`]($link.ref("Video.autoplay")) autoplay (bool) -> [Video]($link.ref("Video"))

If true, the video will start playing automatically. 

### []($heading.id("Video.controls")) [`fn`]($link.ref("Video.controls")) controls (bool) -> [Video]($link.ref("Video"))

If true, the video will display controls (e.g. play/pause, volume). 

### []($heading.id("Video.pip")) [`fn`]($link.ref("Video.pip")) pip (bool) -> [Video]($link.ref("Video"))

If **false**, clients shouldn't try to display the video in a 
Picture-in-Picture context.

### []($heading.id("Video.url")) [`fn`]($link.ref("Video.url")) url (str) -> [Video]($link.ref("Video"))

Sets the source location of this directive to an external URL.

### []($heading.id("Video.asset")) [`fn`]($link.ref("Video.asset")) asset (str) -> [Video]($link.ref("Video"))

Sets the source location of this directive to a page asset.

### []($heading.id("Video.siteAsset")) [`fn`]($link.ref("Video.siteAsset")) siteAsset (str) -> [Video]($link.ref("Video"))

Sets the source location of this directive to a site asset.

### []($heading.id("Video.buildAsset")) [`fn`]($link.ref("Video.buildAsset")) buildAsset (str) -> [Video]($link.ref("Video"))

Sets the source location of this directive to a build asset.

# [Link]($block.id('Link'))

A link.

## Functions

### []($heading.id("Link.url")) [`fn`]($link.ref("Link.url")) url (str) -> [Link]($link.ref("Link"))

Sets the source location of this directive to an external URL.

### []($heading.id("Link.asset")) [`fn`]($link.ref("Link.asset")) asset (str) -> [Link]($link.ref("Link"))

Sets the source location of this directive to a page asset.

### []($heading.id("Link.siteAsset")) [`fn`]($link.ref("Link.siteAsset")) siteAsset (str) -> [Link]($link.ref("Link"))

Sets the source location of this directive to a site asset.

### []($heading.id("Link.buildAsset")) [`fn`]($link.ref("Link.buildAsset")) buildAsset (str) -> [Link]($link.ref("Link"))

Sets the source location of this directive to a build asset.

### []($heading.id("Link.page")) [`fn`]($link.ref("Link.page")) page (str, ?[str]($link.ref("str"))) -> [Link]($link.ref("Link"))

Sets the source location of this directive to a page.

The first argument is a page path, while the second, optional 
argument is the locale code for mulitlingual websites. In 
mulitlingual websites, the locale code defaults to the same
locale of the current content file.

The path is relative to the content directory and should exclude
the markdown suffix as Zine will automatically infer which file
naming convention is used by the target page. 

For example, the value 'foo/bar' will be automatically
matched by Zine with either:
  - content/foo/bar.md
  - content/foo/bar/index.md

### []($heading.id("Link.target")) [`fn`]($link.ref("Link.target")) target (str) -> [Link]($link.ref("Link"))

Sets the target HTML attribute of this link. 

### []($heading.id("Link.ref")) [`fn`]($link.ref("Link.ref")) ref (str) -> [Link]($link.ref("Link"))

Deep-links to a specific section of either the current
page or a target page set with `page()`.

# [Code]($block.id('Code'))

An embedded piece of code.

## Functions

### []($heading.id("Code.asset")) [`fn`]($link.ref("Code.asset")) asset (str) -> [Code]($link.ref("Code"))

Sets the source location of this directive to a page asset.

### []($heading.id("Code.siteAsset")) [`fn`]($link.ref("Code.siteAsset")) siteAsset (str) -> [Code]($link.ref("Code"))

Sets the source location of this directive to a site asset.

### []($heading.id("Code.buildAsset")) [`fn`]($link.ref("Code.buildAsset")) buildAsset (str) -> [Code]($link.ref("Code"))

Sets the source location of this directive to a build asset.

### []($heading.id("Code.language")) [`fn`]($link.ref("Code.language")) language (str) -> [Code]($link.ref("Code"))

Sets the language of this code snippet, which is also used for
syntax highlighting.

