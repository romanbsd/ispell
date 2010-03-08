#!/usr/bin/env ruby
require 'test/unit'
require 'ispell'

class TestIspell < Test::Unit::TestCase
  def setup
    @speller = Ispell.new
    @domain = {
      'cake' => 'cake',
      'caskade' => 'cascade',
      'mantisa' => 'mantissa',
      'phisical' => 'physical'
    }

  end

  def test_suggest
    @domain.each do |pair|
      assert_equal(pair[1], @speller.suggest(pair[0]))
    end
  end

  def test_spellcheck
    assert_equal(:miss, @speller.check('mantisa').at(0).type)
    assert_nil(@speller.check('cake').at(0))
  end
end
