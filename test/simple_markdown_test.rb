# encoding: utf-8
require 'test_helper'
require 'simple_markdown/action_view/helpers'

class SimpleMarkdownTest < ActiveSupport::TestCase # ActionView::TestCase
	include SimpleMarkdown::ActionView::Helpers

  test "truth" do
    assert_kind_of Module, SimpleMarkdown
  end

  test "titles" do
  	1.upto(6) do |i|
  		assert_equal "<h#{i}>Title</h#{i}>", simple_markdown("#{'#'*i} Title")
  	end
 	end

 	test "empty string" do
 		assert_equal "", simple_markdown("")
 	end

	test "empty even with many returns" do
		assert_equal "", simple_markdown("\n\n\n")
	end

 	test "paragraph" do
 		assert_equal "<p>\nText\n</p>", simple_markdown("Text")
 	end

	test "don't add empty <p></p> even with multiple returns" do
		assert_equal "<p>\nText\n</p><p>\nText\n</p>", simple_markdown("Text\n\n\n\n\nText")
	end

 	test "multiple paragraphs" do
 		assert_equal "<p>\nText\n</p><p>\nText2\n</p>", simple_markdown("Text\n\nText2")
 	end

 	test "no <br> with one return without spaces at the end and add space" do
 		assert_equal "<p>\nText and more\n</p>", simple_markdown("Text \nand more")
 	end

 	test "add <br> if return with 2 or more spaces at the end" do
 		assert_equal "<p>\nText <br>\nand more\n</p>", simple_markdown("Text  \nand more")
 	end

	test "link" do
		assert_equal "<p>\n<a href=\"http://example.ch\">link</a>\n</p>", simple_markdown("[link](http://example.ch)")
		assert_equal "<p>\nText <a href=\"http://example.ch\">link</a> text\n</p>", simple_markdown("Text [link](http://example.ch) text")
	end

	test "image" do
		assert_equal "<p>\n<img src=\"http://example.ch\" alt=\"desc\">\n</p>", simple_markdown("![desc](http://example.ch)")
		assert_equal "<p>\nText <img src=\"http://example.ch\" alt=\"desc\"> text\n</p>", simple_markdown("Text ![desc](http://example.ch) text")
	end

 	test "emphasis" do
 		assert_equal "<p>\n<em>Text</em>\n</p>", simple_markdown("*Text*")
		assert_equal "<p>\nText <em>Text</em> text\n</p>", simple_markdown("Text *Text* text")
 	end

 	test "strong" do
 		assert_equal "<p>\n<strong>Text</strong>\n</p>", simple_markdown("**Text**")
		assert_equal "<p>\nText <strong>Text</strong> text\n</p>", simple_markdown("Text **Text** text")
 	end

 	test "list" do
 		assert_equal "<p>\n• Text<br>\n</p>", simple_markdown("* Text")
 	end

 	test "multiple lists" do
 		assert_equal "<p>\n• Text<br>• Text<br>• Text<br>\n</p>", simple_markdown("* Text\n* Text\n* Text")
 	end

 	test "inline code" do
 		# I had to use CGI::escapeHTML in my code to make it work
 		assert_equal "<p>\nThis is <code>#{CGI::escapeHTML('<b>code</b>')}</code>\n</p>", simple_markdown("This is `<b>code</b>`")
 	end

	test "code block" do
		assert_equal "<pre><code>#{CGI::escapeHTML('<b>code</b>')}</code></pre>", simple_markdown("```\n<b>code</b>\n```")
	end

	test "flex block" do
		assert_equal "<div style=\"display:flex; justify-content:space-between; align-items: flex-start;\">\n<div>\n<p>\nThis is text\n</p>\n</div><div>\n<p>\nThis is text\n</p>\n</div>\n</div>",
				simple_markdown("[2flex]\nThis is text\n\n[flex]\nThis is text\n\n[flex]")
	end

	test "flex block with space specified" do
		# skip("flex block is in WIP")
		assert_equal "<div style=\"display:flex; justify-content:space-between; align-items: flex-start;\">\n<div style=\"flex:1;\">\n<p>\nThis is text\n</p>\n</div><div style=\"flex:3;\">\n<p>\nThis is text\n</p>\n</div>\n</div>",
				simple_markdown("[2flex1]\nThis is text\n\n[flex3]\nThis is text\n\n[flex]")
	end

	test "center a line" do
		assert_equal "<p>\n<center>Centered text</center>\n</p>", simple_markdown("->Centered text<-")
	end

	test "center a block" do
		assert_equal "<center>\n<p>\nText\n</p>\n</center>", simple_markdown("->\nText\n\n<-")
		assert_equal "<center>\n<p>\nText\n</p><p>\nText\n</p>\n</center>", simple_markdown("->\n\nText\n\nText\n\n<-")
	end

	test "center a block and add text after" do
		assert_equal "<center>\n<p>\nText\n</p>\n</center><p>\nText\n</p>", simple_markdown("->\n\nText\n\n<-\n\nText")
	end

	test "center a flex" do
		assert_equal "<center>\n<div style=\"display:flex; justify-content:space-between; align-items: flex-start;\">\n<div>\n<p>\nText\n</p>\n</div>\n</div>\n</center><p>\nText\n</p>", simple_markdown("->\n\n[1flex]\n\nText\n\n[flex]\n\n<-\n\nText")
	end

	test "center a title" do
		assert_equal "<center>\n<h1>Title</h1>\n</center>", simple_markdown("->\n#Title\n<-")
	end

end
