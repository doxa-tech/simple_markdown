# encoding: utf-8

module SimpleMarkdown
	module ActionView
		module Helpers

		  @text_map
		  @io
		  @current

		  # Main entry
		  def simple_markdown(text)
		    text = text.gsub(/\r\n?/, "\n").split(/\n/)
		    @text_map = text.map
		    @io = StringIO.new
		    parse_block
		    @io.string.html_safe
		  end

		  private

			def parse_block
				begin
		      while(true)
		        if(@text_map.peek.match(/^$/))  # don't want empty <p></p>
		          @text_map.next
		        elsif @text_map.peek.match(/^\s*```\s*$/) # code block
		          @text_map.next
		          parse_code
		        elsif @text_map.peek.match(/^\s*\#/)
		          parse_title                   # title, only works if has return before (except first time)
		        elsif @text_map.peek.match(/^\s*\[[0-9]+flex\]\s*$/)
		        	@text_map.next
							parse_flex
						else                            # normal block
		          parse_p
		        end
		      end
		    rescue StopIteration
		      # do nothing
		    end
			end

		  def parse_p
				begin
				  @io << "<p>"
					@io << "\n"
					while(!@text_map.peek.match(/^\s*$/)) # end paragraph if empty line
						parse_normal
					end
				rescue StopIteration
					# do nothing
				ensure
					@io << "\n"
					@io << "</p>"
				end
		  end

		  def parse_normal
	      line = @text_map.next
	      line.gsub!(/(^|[^!])\[([^\]]*)\]\(([^\)]*)\)/, "#{'\1'}<a href=\"#{'\3'.strip}\">#{'\2'}</a>") # link
	      line.gsub!(/!\[([^\]]*)\]\(([^\)]*)\)/, "<img src=\"#{'\2'}\" alt=\"#{'\1'.strip}\">") # image
	      line.gsub!(/^\s*\*\s(.*)/, "• #{'\1'}<br>") # list
	      line.gsub!(/`([^`]+)`/) { |match| "<code>#{CGI::escapeHTML(Regexp.last_match[1])}</code>"} # inline code
        line.gsub!(/(^|[^\*])\*([^\*]+)\*/, "#{'\1'}<em>#{'\2'}</em>") # italic
        line.gsub!(/\*\*([^\*]*)\*\*/, "<strong>#{'\1'}</strong>") # bold
        @io << line.gsub(/^([^\s]*)\s+$/, '\1 ') # prints one space if on or more at then end of the line
        @io << "<br>\n" if line.match(/\s{2,}$/) # return if more than 2 spaces at the end of the line
		  end

		  def parse_code
		    @io << "<pre><code>\n"
		    continue = true
		    while(continue)
		      begin
		        line = @text_map.next
		        if line.match(/^\s*```\s*$/)
		          continue = false
		        else
		          @io << CGI::escapeHTML(line)
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

		  def parse_flex
		  	number = @text_map.peek.scan(/[0-9]+/)
		  	@io << "<div style=\"display:flex\">"
		  	1.upto(number) do |i|
					@io << "<div>"
					parse_p
					@io << "</div>"
		  	end
		  	@text_map.next
		  	@io << "</div>"
		  end

			def parse_sub_flex
				line = @text_map.next
				#while(!line.match(/\s*\[flex\]\s*/))
			end

		end
	end
end
