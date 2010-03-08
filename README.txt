= ispell

* http://github.com/romanbsd/ispell

== DESCRIPTION:

This is a ruby interface to the once popular Ispell package.
Please keep in mind, that every instance forks an ispell process.
It was since then mostly superseeded by Aspell, but still remains quite
useful. Especially it has a good support for Russian using ru-ispell
dictionaries.

Ispell is a fast screen-oriented spelling checker that shows you your
errors in the context of the original file, and suggests possible
corrections when it can figure them out.  Compared to UNIX spell, it
is faster and much easier to use.  Ispell can also handle languages
other than English.

== FEATURES/PROBLEMS:

This library was modelled after the Perl ispell module.
However, no support for adding words or modifying the dictionary in any
way is provided at that stage.


== SYNOPSIS:

  require 'ispell'

  speller = Ispell.new('/usr/bin/ispell', 'english')

  speller.suggest('mantisa') # => 'mantissa'
  speller.suggest('cake')    # => 'cake'

  results = speller.spellcheck('hello wonderfull wordl nice 42 trouting')
  puts "Misspelled words: #{results.collect {|w| w.original}.join(',')}"
  results.each do |res|
    case res.type
    when :miss, :guess
      puts "#{res.original} => #{res.guesses.join(',')}"
    when :none
      puts "#{res.original} wasn't found"
    else
      puts "#{res.type.to_s} type of result"
    end
  end

  speller.destroy!

== REQUIREMENTS:

* ispell binary

You can get it from http://fmg-www.cs.ucla.edu/geoff/ispell.html
For Russian dictionaries visit
http://scon155.phys.msu.su/~swan/orthography.html

== INSTALL:

* sudo gem install ispell

== LICENSE:

(The MIT License)

Copyright (c) 2008 Roman Shterenzon

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
