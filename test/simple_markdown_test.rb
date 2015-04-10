require 'test_helper'
require 'simple_markdown/action_view/helpers'

class SimpleMarkdownTest < ActiveSupport::TestCase
	include SimpleMarkdown::ActionView::Helpers

  test "truth" do
    assert_kind_of Module, SimpleMarkdown
  end

  test "markdown" do
  	assert_equal "<h1>Title</h1>", simple_markdown("# Title")
 	end

end
