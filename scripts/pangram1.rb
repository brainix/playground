#!/usr/bin/env ruby

#-----------------------------------------------------------------------------#
#   pangram1.rb                                                               #
#                                                                             #
#   Copyright (c) 2012, Rajiv Bakulesh Shah, original author.                 #
#                                                                             #
#       This file is free software; you can redistribute it and/or modify     #
#       it under the terms of the GNU General Public License as published     #
#       by the Free Software Foundation, either version 3 of the License,     #
#       or (at your option) any later version.                                #
#                                                                             #
#       This file is distributed in the hope that it will be useful, but      #
#       WITHOUT ANY WARRANTY; without even the implied warranty of            #
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     #
#       General Public License for more details.                              #
#                                                                             #
#       You should have received a copy of the GNU General Public License     #
#       along with this file.  If not, see:                                   #
#           <http://www.gnu.org/licenses/>.                                   #
#-----------------------------------------------------------------------------#



require 'set'



def pangram?(sentence)

  # Lowercase the sentence.  Parenthesis are optional for a Ruby method call.
  # We customarily leave them off whenever we call a method and don't pass it
  # any arguments.
  letters = sentence.downcase

  # Strip out all of the non-lowercase-letter characters.  The gsub! method
  # modifies the string in place, whereas the gsub method does not.
  letters.gsub!(/[^a-z]/, '')

  # A Ruby string isn't enumerable.  But a Ruby string has a method, chars,
  # which returns an enumerator.  We need an enumerator, because that's what
  # the set constructor expects, and we want to construct a set.
  letters = letters.chars

  # Construct a set out of the lowercase letters, effectively deduplicating the
  # lowercase letters.
  letters = Set.new(letters)

  # If the sentence is a pangram, our letters set must contain exactly 26
  # elements.
  letters.size == 26

  # A Ruby function can have an explicit return statement, but doesn't require
  # it.  A Ruby function implicitly returns the value of its last evaluated
  # statement.  Good Ruby style is to only use an explicit return statement to
  # terminate a function early (for example, from within an if statement).

# Indented Ruby code requires an explicit end statement.
end



# This is how Ruby determines if a script is run from the command line, or
# loaded from another script or within the interactive interpreter.
if __FILE__ == $0

  # Join all of the command-line arguments into one space-separated string.
  sentence = ARGV.join(' ')

  if pangram?(sentence)
    puts('is a pangram')
  else
    puts('is NOT a pangram')
  end

end
