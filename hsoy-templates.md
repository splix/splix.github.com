---
layout: bigdoc
title: 'Hsoy Templates'
repo: 'hsoy-templates'
---


Introduction
==============

Hsoy Templates is a client- and server- side templating system for web and Java.

Based on Google Closure Templates with adding HAML syntax.

Features
--------

  * One template for both client and server
  * HAML syntax
  * Fast
    * compiled into Java, to run on Server Side
    * compiled into JavaScript, to run in Browser (or NodeJs)
  * Rich command system (based on Google Closure Templates)

License
-------

Licensed under Apache 2 license.

Template Structure
==============


Hsoy Template Example
---------------------

This template:

```haml
!!! namespace tests

/
  Greets a person using "Hello" by default.

  @param name The name of the person.
  @param? greetingWord Optional greeting word to use instead of "Hello".
#greeting
  %h1
    A Greeting
  {if not $greetingWord}
    .default
      Hello {$name}!
  {else}
    .special
      {$greetingWord} {$name}!
  {/if}
```

will generate for `{name: 'John'}`:

```html
<h1>A Greeting</h2>
<div class="default">
 Hello John!
</div>
```

and for `{name: 'Ivan', greetingWord: 'Privet'}`:

```html
<h1>A Greeting</h2>
<div class="special">
 Privet Ivan!
</div>
```


Commands
==============

General syntax
--------------

  * Hsoy Templates uses braces `{}` for commands.
  * use commands `{lb}` and `{rb}` for left- and right brackets if you need to put them into result html
  * open-close block commands: `{if ...} ... {/if}`
  * use indentation for multi line block commands
  * based on Google Closure Templates, so you can also use docs from here: https://developers.google.com/closure/templates/docs/commands

If you need help for HAML syntax - see http://haml.info/

Print value
-----------

For variable use just a `{$variable}` (notice that `$` is placed inside `{}`)

### General syntax:

```
{<expression>}
{print <expression>}
```

### Print Options

You can post process print

<table>
 <tr>
  <th>Option</th>
  <th>Description</th>
 </tr>
 <tr>
   <td>noAutoescape</td>
   <td>turns off autoescaping</td>
 </tr>
 <tr>
   <td>escapeHtml</td>
   <td>manually HTML-escape the output</td>
 </tr>
 <tr>
   <td>escapeUri</td>
   <td>escape the output so that it can be inserted into a URI parameter</td>
 </tr>
 <tr>
   <td>escapeJsString</td>
   <td>escape the output so that it can be inserted into a JavaScript string</td>
 </tr>
 <tr>
   <td>truncate:<n>[,false]</td>
   <td>truncate a string to a maximum length n with trailing ellipsis, optional ',false' to truncate without an ellipsis.</td>
 </tr>
 <tr>
   <td>changeNewlineToBr</td>
   <td>change newlines (\n, \r, or \r\n) to &lt;br&gt;s.</td>
 </tr>
</table>

### Example

```
{<expression> |noAutoescape}
{print <expression> |noAutoescape}
{<expression> |truncate:10,false}
```

If
--

```
{if <expression>} .... {/if}

{if <expression>}
  .hello
    Hello {$variable}!
{/if}

{if <expression>}
  Hello
{elseif <expression>}
  Bueno
{else}
  %span.error hey?!
{/if}
```

where `<expression>` could be:

  * `{if $variable}`
  * `{if $variable > 5}`
  * `{if $variable == $anotherVariable}`
  * `{if not $variable}`
  * `{if $variable and $anotherVariable}`


Loops
-----

```
{foreach <var> in <array>}
  ...
{ifempty}
  ...
{/foreach}
```

The iterator `var` is a local variable that is defined only in the block. Within
the block, you can also use three built-in functions that only take foreach variables as arguments:

  * `isFirst($var)` returns true only on the first iteration.
  * `isLast($var)` returns true only on the last iteration.
  * `index($var)` returns the current index in the list. List indices are 0-based.

JavaScript Usage
==============

TO DO

Java Usage
==============

TO DO

Modules
==============

  * [Hsoy Templates Core](https://github.com/splix/hsoy-templates) - low-level library
  * [Maven Plugin](https://github.com/splix/maven-hsoy-templates)
  * [Grails Plugin](https://github.com/splix/grails-hsoy-templates)

Maven
-----

```xml
<dependency>
    <groupId>com.the6hours</groupId>
    <artifactId>hsoy-templates</artifactId>
    <version>0.4</version>
</dependency>
```

+ you need extra repository:

```xml
<repositories>
    <repository>
        <id>the6hours-release</id>
        <url>http://maven.the6hours.com/release</url>
        <releases><enabled>true</enabled></releases>
        <snapshots><enabled>false</enabled></snapshots>
    </repository>
</repositories>
```

Links
==============


  * https://developers.google.com/closure/templates/docs/ - docs for Google Closure Templates (internal engine for Hsoy Templates)
  * http://haml.info/ - HAML syntax


