#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   pangram3.rb                                                              #
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


require 'rake'
require 'set'


# We're going to monkey patch our own is_pangram method into Ruby's String
# class.  However, we want to do this in a kind, gentle way.  Therefore, we're
# going to create a module, with our own String class, with our method that
# we're going to tack on Ruby's String class.  We jump through these hoops so
# that String.ancestors shows our module to help others debug.
#
# For more information, see:
#   http://johnragan.wordpress.com/2010/02/22/safer-monkey-patching/

module Pangram
  module String
    rake_extension('is_pangram') do
      def is_pangram
        letters = self.downcase
        letters.gsub!(/[^a-z]/i, '')
        letters = letters.chars
        letters = Set.new(letters)
        letters.size == 26
      end
    end
  end
end


class String
  include Pangram::String
end


if __FILE__ == $0
  sentence = ARGV.join(' ')
  if sentence.is_pangram
    puts('is a pangram')
  else
    puts('is NOT a pangram')
  end
end
