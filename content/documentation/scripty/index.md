---
{
    .title = "Scripty Reference",
    .description = "",
    .author = "Loris Cro",
    .layout = "scripty-reference.html",
    .date = @date("2023-06-16T00:00:00"),
    .draft = false,
}
---
# Globals
## $site : Site

The global site configuration. The fields come from the call to 
`addWebsite` in your `build.zig`.
## $page : Page

The current page.
## $loop : ?Loop

The iteration element in a loop, only available inside of elements with a `loop` attribute.
## $if : ?V

The payload of an optional value, only available inside of elemens with an `if` attribute.
# Types
## Site
### base_url : str,
  ### title : str,
  ## Page
### title : str,
  ### description : str = "",
  ### author : str,
  ### date : date,
  ### layout : str,
  ### draft : bool = false,
  ### tags : [str] = [],
  ### aliases : [str] = [],
  ### alternatives : [Alternative] = {  },
  ### skip_subdirs : bool = false,
  ### custom : dyn = ziggy.dynamic.Value{ .null = void },
  ### content : str = "",
  ### wordCount() -> int
Returns the word count of the page.

The count is performed assuming 5-letter words, so it actually
counts all characters and divides the result by 5.

Examples:
```
<div loop="$page.wordCount()"></div>
``` 
### isSection() -> bool
Returns true if the current page defines a section (i.e. if 
the current page is an 'index.md' page).


Examples:
```
<div ></div>
``` 
### subpages() -> [Page]
Only available on 'index.md' pages, as those are the pages
that define a section.

Returns a list of all the pages in this section.


Examples:
```
<div loop="$page.subpages()"><span var="$loop.it.title"></span></div>
``` 
### nextPage() -> ?Page
Tries to return the page after the target one (sorted by date), to be used with an `if` attribute.

Examples:
```
<div if="$page.nextPage()"></div>
``` 
### prevPage() -> ?Page
Tries to return the page before the target one (sorted by date), to be used with an `if` attribute.

Examples:
```
<div if="$page.prevPage()"></div>
``` 
### hasNext() -> bool
Returns true of the target page has another page after (sorted by date) 

Examples:
```
$page.hasNext()
``` 
### hasPrev() -> bool
Returns true of the target page has another page before (sorted by date) 

Examples:
```
$page.hasPrev()
``` 
### permalink() -> str
Returns the URL of the target page.

Examples:
```
$page.permalink()
``` 
## Alternative
### layout : str,
  ### output : str,
  ### title : str = "",
  ### type : str = "",
  ## str
### len() -> int
Returns the length of a string.


Examples:
```
$page.title.len()
``` 
### suffix(str, [...str]) -> str
Concatenates strings together (left-to-right).


Examples:
```
$page.title.suffix("Foo","Bar", "Baz")
``` 
### syntaxHighlight(str) -> str
Applies syntax highlighting to a string.
The argument specifies the language name.


Examples:
```
<pre><code class="ziggy" var="$page.custom.get('sample', '').syntaxHighLight('ziggy')"></code></pre>
``` 
## date
### gt(date) -> bool
Return true if lhs is later than rhs (the argument).


Examples:
```
$page.date.gt($page.custom.expiry_date)
``` 
### lt(date) -> bool
Return true if lhs is earlier than rhs (the argument).


Examples:
```
$page.date.lt($page.custom.expiry_date)
``` 
### eq(date) -> bool
Return true if lhs is the same instant as the rhs (the argument).


Examples:
```
$page.date.eq($page.custom.expiry_date)
``` 
### format(str) -> str
Formats a datetime according to the specified format string.


Examples:
```
$page.date.format("January 02, 2006")
$page.date.format("06-Jan-02")
``` 
### formatHTTP() -> str
Formats a datetime according to the HTTP spec.


Examples:
```
$page.date.formatHTTP()
``` 
## int
### eq(int) -> bool
Tests if two integers have the same value.


Examples:
```
$page.wordCount().eq(200)
``` 
### gt(int) -> bool
Returns true if lhs is greater than rhs (the argument).


Examples:
```
$page.wordCount().gt(200)
``` 
### plus(int) -> int
Sums two integers.


Examples:
```
$page.wordCount().plus(10)
``` 
### div(int) -> int
Divides the receiver by the argument.


Examples:
```
$page.wordCount().div(10)
``` 
## bool
### then(dyn, dyn) -> dyn
If the boolean is `true`, returns the first argument.
Otherwise, returns the second argument.


Examples:
```
$page.draft.then("<alert>DRAFT!</alert>", "")
``` 
### not() -> bool
Negates a boolean value.


Examples:
```
$page.draft.not()
``` 
### and(bool, [...bool]) -> bool
Computes logical `and` between the receiver value and any other value passed as argument.


Examples:
```
$page.draft.and($site.tags.len().eq(10))
``` 
### or(bool, [...bool]) -> bool
Computes logical `or` between the receiver value and any other value passed as argument.


Examples:
```
$page.draft.or($site.tags.len().eq(0))
``` 
## dyn
### get?(str) -> ?dyn
Tries to get a dynamic value, to be used in conjuction with an `if` attribute.


Examples:
```
<div if="$page.custom.get?('myValue')"></div>
``` 
### get!(str) -> dyn
Tries to get a dynamic value, errors out if the value is not present.


Examples:
```
$page.custom.get!('coauthor')
``` 
### get(str, dyn) -> dyn
Tries to get a dynamic value, returns the second value on failure.


Examples:
```
$page.custom.get('coauthor', 'Loris Cro')
``` 
