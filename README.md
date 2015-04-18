[![Gem Version](https://badge.fury.io/rb/simple_markdown.svg)](http://badge.fury.io/rb/simple_markdown) [![Build Status](https://travis-ci.org/JS-Tech/simple_markdown.svg?branch=master)](https://travis-ci.org/JS-Tech/simple_markdown)

# SimpleMarkdown

This project rocks and uses MIT-LICENSE.

**Note** : does not provide an exhaustive markdown parser. It is intended only to give the most simple and usefull syntax, so as to keep it simple (stupid?).

# Features

* Titles with
```
# Title 1
## Title 2
...
###### Title 6
```
* List with (only)
```
* Apple
* Banana
```
* Emphasis with
```
This is *emphasis* test
```
* Bold with
```
This is **bold test**
```
* Image with
```
This is an image : [description](http://example.com/im.png)
```
* Link with
```
This is a ![link](http://example.com)
```

# Special non-markdown
I haded the ability to make horizontal block.

* Two horizontal block with
```
[2flex]

flex block number one with
* a list

[flex]

flex block number two
\```
a code block
\```

[flex]

Normal paragraph, not in block.
```

* You can specify the with of each block, relative to the others with
```
[2flex1]

This block n°1 has 1/3 of the width

[flex2]

This block n°2 has 2/3 of the with

[flex]
```
