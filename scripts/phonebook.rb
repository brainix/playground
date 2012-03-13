#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   phonebook.rb                                                             #
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

  def validate_input(s)
    s
  end

  # This Node class implements an n-ary tree that represents a phone book.  The
  # tree allows us to add, look up, and remove phone numbers.
  #
  # Each node in the tree represents one digit in at least one phone number.
  # The memory win, though, is that a node could represent a digit in multiple
  # phone numbers.  I can best illustrate this through an example:
  #
  # Suppose we start with an empty phone book and add the number 713-725-8220.
  # We give the root node a '7' child, that '7' node a '1' child, that '1' node
  # a '3' child, that '3' node a '7' child, and so on.
  #
  # Then suppose I add a second number 713-894-4246.  The root node already has
  # a '7' child, which already has a '1' child, which already has a '3' child
  # from the first number!  So when adding this second number, we don't
  # duplicate this already stored data.  We simply traverse the tree and
  # diverge at the '3' node.  The '3' node has a '7' child from the first
  # number.  So for our second number, we give the '3' node an '8' child and
  # continue from there.
  #
  # This implementation is elegant and memory-efficient, but it has some
  # drawbacks:
  #   1.  No duplicate phone numbers.
  #   2.  No way to differentiate a part from a whole.
  #       A.  If I were to add 713-725-8220, then look up 713 - the phone book
  #           would report that 713 exists.
  #       B.  If I were to add 713-725-8220, then add 713, then remove 713,
  #           then look up 713 - the phone book would report that 713 exists.
  #       C.  If I were to add 713, then add 713-725-8220, then remove
  #           713-725-8220, then look up 713 - the phone book would report that
  #           713 doesn't exist.
  #   4.  Recursion.  If Ruby is like Python, method calls are expensive, so
  #       recursion probably isn't the most efficient approach.
  #
  # However, we're targetting clean and well ordered data (only phone numbers,
  # not arbitrary strings).  We take advantage of the memory savings because
  # there's lots of repeated data in the area codes alone.  We don't care about
  # the part/whole problem because we add, look up, and remove only complete
  # 10-digit phone numbers.  We don't care about the cost of recursion because
  # in the worst case, we only make 10 recursive method calls (so the clarity
  # of recursion beats the efficiency of iteration).  This seems like a good
  # approach.
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
