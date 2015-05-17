[![Gem Version](https://badge.fury.io/rb/simple_markdown.svg)](http://badge.fury.io/rb/simple_markdown)
[![Build Status](https://travis-ci.org/JS-Tech/simple_markdown.svg?branch=master)](https://travis-ci.org/JS-Tech/simple_markdown)
[![Coverage Status](https://coveralls.io/repos/JS-Tech/simple_markdown/badge.svg)](https://coveralls.io/r/JS-Tech/simple_markdown)
[![Code Climate](https://codeclimate.com/github/JS-Tech/simple_markdown/badges/gpa.svg)](https://codeclimate.com/github/JS-Tech/simple_markdown)

# SimpleMarkdown

This project rocks and uses MIT-LICENSE.

**Note** : does not provide an exhaustive markdown parser. It is intended only to give the most simple and usefull syntax, so as to keep it simple (stupid?).

# Installation

```
# Gemfile
source 'https://rubygems.org'
gem 'simple_markdown'
```

Then run `bundle install`.

Can also do `gem install simple_markdown`

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

# Special non-markdown, consider it as an extra DSL

I aded the ability to make horizontal blocks.

* Two horizontal block with (specify the number of block in the first tag)

```
[2-flex]

This is the flex block number one, with
* a list

[flex]

This is the flex block number two
\```
a code block (backticks escaped with '\')
\```

[flex]

Normal paragraph, not in block.
```

* You can specify the width of each block, relative to the other ones

```
[2-flex-4]

This block n°1 has 4/5th of the width

[flex-1]

This block n°2 has 1/5th of the with

[flex]
```

* center content with

```
->Centered text<-
```

```
->

# Centerd title

<-
```
