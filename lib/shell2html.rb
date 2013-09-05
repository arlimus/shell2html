require 'eventmachine'
require 'rb-readline'

module ExecSimple

  def exec_simple( cmd, itemizer = nil )

    cmd_escaped = cmd.gsub(/\\/,'\\\\\\\\').gsub(/["]/,'\"')
    cmd = "sh -c \"#{cmd_escaped}\""

    res = nil
    EM::run do
      res = EM::popen( cmd, ResultCache, itemizer )
    end
    res.items
  end

  private

  class ResultCache < EM::Connection
    include EM::Protocols::LineText2
    attr_reader :itemizer, :items

    def initialize(itemizer)
      @items = []
      @itemizer = lambda {|i| i }
      @itemizer = itemizer if itemizer.is_a?(Proc)
    end

    def receive_line(data)
      @items.push @itemizer.(data)
    end

    def unbind
      EM::stop
    end
  end

end


# hotfix broken CTRL+forward/backward in shell
# (at least on my keyboard layout, where the default input has bold-style)
# (ie ansi-escape \e[1m which is not read correctly)
module Readline
  def self.set_key_to x, y
    RbReadline.rl_bind_keyseq_if_unbound(x,y)
  end
end
Readline::set_key_to "\033[1;5C", :rl_forward_word
Readline::set_key_to "\033[1;5D", :rl_backward_word


class Shell2Html
  include ExecSimple
  
  def self.version; "0.1" end

  def initialize output = nil, options
    @output = output
    @options = options
    @cache = []
    @html = ""
  end

  def repl
    # http://bogojoker.com/readline/
    stty_save = `stty -g`.chomp
    trap('INT') do
      system('stty', stty_save)
      finish
    end

    add_history_to_readline

    loop do
      line = Readline::readline('> ')
      break if line.nil?
      Readline::HISTORY.push(line)
      run line
    end
  end

  def run cmd
    if cmd == 'exit' or cmd == 'quit'
      finish
    end

    r = exec_simple cmd, lambda{|i|
      puts i
      i
    }

    @cache.push([cmd, r.join("\n")])
  end

  def finish
    opts_bg = ( @options[:bg].nil? or @options[:bg] != 'dark' ) ? '' : "--bg=dark"
    opts_palette = ( @options[:palette].nil? ) ? '' : "--palette=#{@options[:palette]}"

    IO.popen("ansi2html #{opts_bg} #{opts_palette}",'r+') do |pipe|
      @cache.each do |cc|
        pipe.puts("> #{cc[0]}")
        pipe.puts(cc[1])
        pipe.puts(SEPARATOR)
      end
      pipe.close_write
      @html = pipe.read.gsub /#{SEPARATOR}/, "\n<hr/>\n"
    end

    if @output.nil?
      puts @html
    else
      File::write @output, @html
    end

    exit 0
  end

  private

  SEPARATOR = "THIS_IS_A_HUGE_HONKING_SEPARATOR_WHICH_IS_TURNED_INTO_A_HORIZONTAL_RULE"

  def add_history_to_readline
    history_files = %w{ ~/.history ~/.zsh_history ~/.bash_history}

    # find the history file that was last modified
    candidates = history_files.map do |f|
        File::expand_path f
      end.find_all do |f|
        File::file? f
      end.sort_by do |f|
        File::stat(f).mtime
      end

    # add the history
    if candidates.empty?
      puts "Can't find any shell history in: #{history_files.join(', ')}"
    else
      p candidates.last
      r = File::read( candidates.last )
      # work around an edge-case in encoding:
      # http://stackoverflow.com/questions/10466161/ruby-string-encode-still-gives-invalid-byte-sequence-in-utf-8/10466273#10466273
      s = r.force_encoding('binary').encode('utf-8', :invalid => :replace, :undef => :replace)
      ls = s.split("\n")
      # work around zsh formatting of history:
      if candidates.last.end_with? "/.zsh_history"
        # : 1378387078:0;ls
        ls = ls.map{|l| l.sub /^:\s[0-9]+:[0-9]+;/, ''}
      end
      # add each line to the history
      ls.each{|l| Readline::HISTORY.push(l)}
    end
  end
end
