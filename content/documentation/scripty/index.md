---
{
  "title": "Scripty Reference",
  "description": "", 
  "author": "Loris Cro",
  "layout": "scripty-reference.html",
  "date": "2023-06-16T00:00:00",
  "draft": false
}
---
# Globals
## $site : Site

Represents the global site configuration.
## $page : Page

Represents the current page.
## $loop : ?Loop

The iteration element in a loop, only available inside of elements with a `loop` attribute.
## $if : ?V

The payload of an optional value, only available inside of elemens with an `if` attribute.
# Types
## Site
### base_url : str,
  ### title : str,
  ### pages() -> [Page...]
Returns a list of all the pages of the website. 
To be used in conjuction with a `loop` attribute. 


Examples:
```
<div loop="$site.pages()"></div>
``` 
## Page
### title : str,
  ### description : str,
  ### author : str,
  ### date : date,
  ### layout : str,
  ### draft : bool,
  ### tags : [str...],
  ### aliases : [str...],
  ### custom : dyn,
  ### content : str,
  ### wordCount() -> int
Returns the word count of the page.

The count is performed assuming 5-letter words, so it actually
counts all characters and divides the result by 5.

Examples:
```
<div loop="$site.pages()"></div>
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
## str
### len() -> int
Returns the length of a string.


Examples:
```
$page.title.len()
``` 
### suffix(str, [str...]) -> str
Concatenates strings together (left-to-right).


Examples:
```
$page.title.suffix("Foo","Bar", "Baz")
``` 
## date
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
### not() -> bool
Negates a boolean value.


Examples:
```
$page.draft.not()
``` 
### and(bool, [bool...]) -> bool
Computes logical `and` between the receiver value and any other value passed as argument.


Examples:
```
$page.draft.and($site.base_url.startsWith("https"))
``` 
### or(bool, [bool...]) -> bool
Computes logical `or` between the receiver value and any other value passed as argument.


Examples:
```
$page.draft.or($site.base_url.startsWith("https"))
``` 
## dyn
### get?(str) -> ?dyn
Tries to get a dynamic value, to be used in conjuction with an `if` attribute.


Examples:
```
<div if="$page.custom.get?('myValue')"></div>
``` 
### get(str, str) -> str
Tries to get a dynamic value, uses the provided default value otherwise.


Examples:
```
$page.custom.get('coauthor', 'nobody')
``` 
