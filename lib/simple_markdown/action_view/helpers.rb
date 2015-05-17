# encoding: utf-8

module SimpleMarkdown
  module ActionView
    module Helpers

      USELESS_LINE = /^$/
      CODE_BLOCK   = /^\s*```\s*$/
      CODE_INLINE  = /`([^`]+)`/
      TITLE        = /^\s*\#/
      FLEX_HEAD    = /^\s*\[[0-9]+-?flex-?[0-9]*\]\s*$/
      FLEX         = /^\s*\[flex-?[0-9]*\]\s*$/
      CENTER_BLOCK_1 = /^\s*->\s*$/
      CENTER_BLOCK_2 = /^\s*<-\s*/
      CENTER_INLINE  = /^\s*->(.*)<-(\s*)$/
      LINK         = /(^|[^!])\[([^\]]*)\]\(([^\)]*)\)/
      IMAGE        = /!\[([^\]]*)\]\(([^\)]*)\)/
      LIST         = /^\s*\*\s(.*)/
      ITALIC       = /(^|[^\*])\*([^\*]+)\*/
      BOLD         = /\*\*([^\*]*)\*\*/
      RETURN       = /\s{2,}$/

      @text_map
      @io
      @current

      # Main entry
      def simple_markdown(text)
        text = text.gsub(/\r\n?/, "\n").split(/\n/)
        @text_map = text.map
        @io = StringIO.new
        begin
          while(true)
            parse_block
          end
        rescue StopIteration
        ensure
          return @io.string.html_safe
        end
      end

      private

      def parse_block
        if @text_map.peek.match(USELESS_LINE)  # don't want empty <p></p>
          @text_map.next
        elsif @text_map.peek.match(CODE_BLOCK) # code block
          @text_map.next
          parse_code
        elsif @text_map.peek.match(TITLE)
          parse_title                  # title, only works if has return before (except first time)
        elsif @text_map.peek.match(FLEX_HEAD)
          parse_flex
        elsif @text_map.peek.match(CENTER_BLOCK_1)
          parse_center
        else                            # normal block
          parse_p
        end
      end

      def parse_p
        begin
          @io << "<p>\n"
          while(!@text_map.peek.match(USELESS_LINE)) # end paragraph if empty line
            parse_normal
          end
          @text_map.next;
        rescue StopIteration
          # do nothing
        ensure
          @io << "\n</p>"
        end
      end

      def parse_normal
        line = @text_map.next
        line.gsub!(CENTER_INLINE, "<center>#{'\1'}</center>#{'\2'}")
        line.gsub!(LINK, "#{'\1'}<a href=\"#{'\3'.strip}\">#{'\2'}</a>") # link
        line.gsub!(IMAGE, "<img src=\"#{'\2'}\" alt=\"#{'\1'.strip}\">") # image
        line.gsub!(LIST, "• #{'\1'}<br>") # list
        line.gsub!(CODE_INLINE) { |match| "<code>#{CGI::escapeHTML(Regexp.last_match[1])}</code>"} # inline code
        line.gsub!(ITALIC, "#{'\1'}<em>#{'\2'}</em>") # italic
        line.gsub!(BOLD, "<strong>#{'\1'}</strong>") # bold
        @io << line.gsub(/^([^\s]*)\s+$/, '\1 ') # prints one space if one or more at then end of the line
        @io << "<br>\n" if line.match(RETURN) # return if more than 2 spaces at the end of the line
      end

      def parse_code
        @io << "<pre><code>"
        continue = true
        while(continue)
          # begin
            line = @text_map.next
            if line.match(CODE_BLOCK)
              continue = false
            else
              @io << CGI::escapeHTML(line)
              @io << "\n" unless @text_map.peek.match(CODE_BLOCK)
            end
          # rescue StopIteration
          #   continue = false
          # end
        end
        @io << "</code></pre>"
      end

      def parse_title
        line = @text_map.next
        line.gsub!(/^\s*(\#{1,6})(.*)$/) { |match|
          num = Regexp.last_match[1].size # number of # = type of <hn></hn>
          "<h#{num}>#{Regexp.last_match[2].strip}</h#{num}>"
        }
        @io << line
      end

      def parse_flex
        # begin
          @io << "<div style=\"display:flex; justify-content:space-between; align-items: flex-start;\">\n"
          line = @text_map.next
          scan = line.scan(/[0-9]+/)
          number = scan[0].to_i
          space = scan[1]
          1.upto(number) do |i|
            if space
              @io << "<div style=\"flex:#{space};\">\n"
            else
              @io << "<div>\n"
            end
            while(!@text_map.peek.match(FLEX))
              parse_block
            end
            line = @text_map.next
            space = line.scan(/[0-9]+/)[0]
            @io << "\n</div>"
          end
        # rescue StopIteration
        #   # do nothing
        # ensure
          @io << "\n</div>"
        # end
      end

      def parse_center
        @io << "<center>\n"
        @text_map.next
        while(!@text_map.peek.match(CENTER_BLOCK_2))
          parse_block
        end
        @io << "\n</center>"
        @text_map.next
      end

    end
  end
end
