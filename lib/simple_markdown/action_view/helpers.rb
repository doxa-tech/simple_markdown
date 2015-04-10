# encoding: utf-8

module SimpleMarkdown
	module ActionView
		module Helpers

		  @text_map
		  @io
		  @current
		  @continue

		  # Main entry
		  def simple_markdown(text)
		    text = text.gsub(/\r\n?/, "\n").split(/\n/)
		    @text_map = text.map
		    @io = StringIO.new
		    parse_p
		    @io.string.html_safe
		  end

		  private

		  def parse_p
		    @continue = true
		    begin
		      while(@continue)
		        if(@text_map.peek.match(/^$/))  # don't want empty <p></p>
		          @text_map.next
		        elsif @text_map.peek.match(/^\s*```\s*$/) # code block
		          @text_map.next
		          parse_code
		        elsif @text_map.peek.match(/^\s*\#/)
		          parse_title                   # title, only works if has return before
		        else                            # normal block
		          @io << "<p>"
		          @io << "\n"
		          parse_normal
		          @io << "\n"
		          @io << "</p>"
		        end
		      end
		    rescue
		      # do nothing
		    end
		  end

		  def parse_normal
		  	first_time = true
		    begin
		      line = @text_map.next
		      while(!line.match(/^\s*$/)) # end paragraph if empty line
		        line.gsub!(/(^|[^!])\[([^\]]*)\]\(([^\)]*)\)/, "#{'\1'}<a href=\"#{'\3'.strip}\">#{'\2'}</a>") # link
		        line.gsub!(/!\[([^\]]*)\]\(([^\)]*)\)/, "<img src=\"#{'\2'}\" alt=\"#{'\1'.strip}\">") # link
		        line.gsub!(/^\s*\*\s(.*)/, "• #{'\1'}<br>") # list
		        line.gsub!(/`([^`]+)`/) { |match| "<code>#{h(Regexp.last_match[1])}</code>"} # inline code
		        line.gsub!(/(^|[^\*])\*([^\*]+)\*/, "#{'\1'}<em>#{'\2'}</em>") # italic
		        line.gsub!(/\*\*([^\*]*)\*\*/, "<strong>#{'\1'}</strong>") # bold
		        if(first_time)
		        	first_time = false
		 				else
		 					@io << " "
		        end
		        @io << line
		        @io << "<br>\n" if line.match(/\s{2,}$/) # return if more than 2 spaces at the end of the line
		        line = @text_map.next
		      end
		    rescue StopIteration
		      @continue = false
		    end
		  end

		  def parse_code
		    @io << "<pre><code>"
		    continue = true
		    while(continue)
		      begin
		        line = @text_map.next
		        if line.match(/^\s*```\s*$/)
		          continue = false
		        else
		          @io << h(line)
		          @io << "\n"
		        end
		      rescue StopIteration
		        continue = false
		      end
		    end
		    @io << "</code></pre>"
		  end

		  def parse_title
		    line = @text_map.next
		    line.gsub!(/^\s{0,4}(\#{1,6})(.*)$/) { |match|
		      num = Regexp.last_match[1].size # number of # = type of <hn></hn>
		      "<h#{num}>#{Regexp.last_match[2].strip}</h#{num}>"
		    }
		    @io << line
		  end

		end
	end
end