#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   phonebook1.rb                                                            #
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


# This PhoneBook class is a wrapper around the Node class.  The interesting
# stuff is in the Node class below.
class PhoneBook

  def initialize
    @node = Node.new
  end

  def insert(s)
    s = validate_input(s)
    @node.insert(s)
  end

  def find(s)
    s = validate_input(s)
    @node.find(s)
  end

  def delete(s)
    s = validate_input(s)
    @node.delete(s)
  end

  private

  # Validate phone number input.  Ensure it's of the form: 713-725-8220  Then
  # strip out the hyphens.
  def validate_input(s)
    regex = /^\d{3}-\d{3}-\d{4}$/
    match = s =~ regex
    if match.nil?
      raise ArgumentError, 'phone number must be of form: 713-725-8220'
    end
    s.gsub(/[^0-9]/, '')
  end

  # This Node class implements an n-ary tree that represents a phone book.  The
  # tree allows us to add, look up, and remove phone numbers.
  #
  # Each node in the tree represents one digit in at least one phone number.
  # The memory win, though, is that a node could represent a digit in multiple
  # phone numbers.  If two phone numbers start with the same area code, their
  # traversal paths down the tree start with the same three nodes, then
  # diverge.  The full phone numbers aren't stored anywhere in the tree, but
  # can be derived through their traversal paths.  Each path down the tree
  # represents one phone number.
  #
  # This implementation is elegant and memory-efficient, but has some
  # drawbacks:
  #   1.  No duplicate phone numbers.
  #   2.  No way to differentiate a part from a whole.
  #       A.  Add 713-725-8220, then look up 713 - the tree reports that 713
  #           exists.
  #       B.  Add 713, then add 713-725-8220, then remove 713-725-8220, then
  #           look up 713 - the tree reports that 713 doesn't exist.
  #   3.  No way to meaningfully sort phone numbers.
  #   4.  Recursion probably isn't the most efficient approach.
  #
  # However, we're targetting well ordered data (only 10-digit phone numbers,
  # not arbitrary strings) for a specific use case.  So for us, the advantages
  # outweigh the disadvantages.
  class Node

    attr_reader :children

    def initialize
      @children = {}
    end

    def insert(s)
      unless s.empty?
        @children[s[0]] = Node.new if @children[s[0]].nil?
        @children[s[0]].insert(s[1..-1])
      end
    end

    def find(s)
      return true if s.empty?
      return false if @children[s[0]].nil?
      @children[s[0]].find(s[1..-1])
    end

    def delete(s)
      unless s.empty?
        @children[s[0]].delete(s[1..-1]) unless @children[s[0]].nil?
        @children.delete(s[0]) if @children[s[0]].children.empty?
      end
    end

  end

end
