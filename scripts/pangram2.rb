#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   pangram2.rb                                                              #
#                                                                            #
#   Copyright (c) 2012, Rajiv Bakulesh Shah, original author.                #
#                                                                            #
#       This file is free software; you can redistribute it and/or modify    #
#       it under the terms of the GNU General Public License as published    #
#       by the Free Software Foundation, either version 3 of the License,    #
#       or (at your option) any later version.                               #
#                                                                            #
#       This file is distributed in the hope that it will be useful, but     #
#       WITHOUT ANY WARRANTY; without even the implied warranty of           #
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU    #
#       General Public License for more details.                             #
#                                                                            #
#       You should have received a copy of the GNU General Public License    #
#       along with this file.  If not, see:                                  #
#           <http://www.gnu.org/licenses/>.                                  #
#----------------------------------------------------------------------------#


require 'set'


# This is how we define a new class Pangram that inherits from the class
# String.
class Pangram < String

  # Override the String class's initialize method.  Only allow pangrams to be
  # set in our Pangram class, then call the String class's initialize method,
  # then freeze our Pangram instance (make our Pangram instance immutable).
  def initialize(s)
    raise ArgumentError, 'string is not a pangram' unless is_pangram(s)
    super
    self.freeze
  end

  # Ruby has private methods.  Every method after this line until the end of
  # the class definition is private.  (Though, this isn't necessary for the
  # initialize method since it's private by default.)
  private

  def is_pangram(s)
    letters = s.downcase
    letters.gsub!(/[^a-z]/, '')
    letters = letters.chars
    letters = Set.new(letters)
    letters.size == 26
  end

end


if __FILE__ == $0
  sentence = ARGV.join(' ')
  begin
    pangram = Pangram.new(sentence)
  rescue ArgumentError
    puts('is NOT a pangram')
  else
    puts('is a pangram')
  end
end
