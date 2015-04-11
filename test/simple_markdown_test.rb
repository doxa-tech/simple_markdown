# encoding: utf-8
require 'test_helper'
require 'simple_markdown/action_view/helpers'

class SimpleMarkdownTest < ActiveSupport::TestCase # ActionView::TestCase
	include SimpleMarkdown::ActionView::Helpers

  test "truth" do
    assert_kind_of Module, SimpleMarkdown
  end

  test "test titles" do
  	1.upto(6) do |i|
  		assert_equal "<h#{i}>Title</h#{i}>", simple_markdown("#{'#'*i} Title")
  	end
 	end

 	test "empty string" do
 		assert_equal "", simple_markdown("")
 	end

 	test "paragraph" do
 		assert_equal "<p>\nText\n</p>", simple_markdown("Text")
 	end

 	test "multiple paragraphs" do
 		assert_equal "<p>\nText\n</p><p>\nText2\n</p>", simple_markdown("Text\n\nText2")
 	end

 	test "no <br> with one return without spaces at the end and add space" do
 		assert_equal "<p>\nText and more\n</p>", simple_markdown("Text\nand more")
 	end

 	test "add <br> if return with 2 or more spaces at the end" do
 		assert_equal "<p>\nText  <br>\n and more\n</p>", simple_markdown("Text  \nand more")
 	end

 	test "emphasis" do
 		assert_equal "<p>\n<em>Text</em>\n</p>", simple_markdown("*Text*")
 	end

 	test "strong" do
 		assert_equal "<p>\n<strong>Text</strong>\n</p>", simple_markdown("**Text**")
 	end

 	test "list" do
 		assert_equal "<p>\n• Text<br>\n</p>", simple_markdown("* Text")
 	end

 	test "multiple lists" do
 		assert_equal "<p>\n• Text<br> • Text<br> • Text<br>\n</p>", simple_markdown("* Text\n* Text\n* Text")
 	end

 	test "inline code" do
 		assert_equal "<p>\n", simple_markdown("This is `code`")
 	end

end
