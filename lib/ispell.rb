class Ispell
  VERSION = '0.1.1'

  class Result
    TYPES = { '*' => :ok, '+' => :root, '&' => :miss,
      '?' => :guess, '-' => :compound, '#' => :none }
    attr_accessor :type, :root, :original, :offset, :count, :guesses

    # Freezes all instance variables
    def freeze!
      instance_variables.each {|v| eval("#{v}.freeze")}
      self
    end
  end

  # Create new speller instance, optionally can specify the ispell binary
  # and the desired language.
  def initialize(ispell='/usr/bin/ispell', lang='english')
    @ispell_bin, @lang = ispell, lang
    @options = ['-a','-S',"-d #{lang}"]
    @ispell = nil
    start!
  end

  # Consider run-together words as legal compounds.
  def allow_compounds!(bool = true)
    if bool
      @options.delete('-B')
      @options.unshift('-C')
    else
      @options.delete('-C')
      @options.unshift('-B')
    end
    restart!
  end

  # Make  possible root/affix combinations that aren't in the dictionary.
  def make_wild_guesses!(bool = true)
    if bool
      @options.delete('-P')
      @options.unshift('-m')
    else
      @options.delete('-m')
      @options.unshift('-P')
    end
    restart!
  end

  # Spell check the provided line, returns an +Array+ of +Ispell::Result+
  def spellcheck(line)
    line.gsub!(/\r/n,'')
    line.gsub!(/\s+/n, ' ')
    results = to_ispell(line)
    results.collect do |line|
      tokens = line.split(/,?:?\s+/n)
      res = Result.new
      res.type = Result::TYPES[tokens.shift]
      case res.type
      when :root
        res.root = tokens.shift
      when :none
        res.original = tokens.shift
        res.offset = tokens.shift
      when :miss, :guess
        res.original = tokens.shift
        res.count = tokens.shift
        res.offset = tokens.shift
        res.guesses = tokens
      end
      res.freeze!
    end
  end
  alias :check :spellcheck

  # Suggest a replacement for a given word, or the word itself if it's ok.
  # Picks the first word from the suggestions list.
  # If the word wasn't found, for leave_erroneous=true the original word 
  # is returned, for leave_erroneous=false an empty string is returned.
  def suggest(word, leave_erroneous=false)
    res = spellcheck(word).at(0)
    return word unless res
    case res.type
    when :ok
      return word
    when :miss, :guess
      return res.guesses.at(0)
    when :none
      return leave_erroneous ? word : ''
    else
      return ''
    end
  end

  # Stop the ispell
  def destroy!
    @ispell.close
    @ispell = nil
  end

  # Start the ispell
  def start!
    return if @ispell
    @ispell = IO.popen("#{@ispell_bin} #{@options.join(' ')}", 'r+')
    # Swallow the greeting line
    @ispell.gets
    # Turn on the terse mode
    @ispell.puts('!')
  end

  # Restart the ispell
  def restart!
    destroy!
    start!
  end

  private
  # Send a line to ispell and return the result as array
  def to_ispell(line)
    raise "Ispell not running" unless @ispell
    @ispell.puts(line)
    lines = []
    while ! (line = @ispell.gets).eql?("\n")
      lines.push(line)
    end
    lines
  end
end
