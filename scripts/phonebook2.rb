#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   phonebook2.rb                                                            #
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


class PhoneBook

  def initialize
    @node = Node.new
  end

  # In phonebook1.rb, look at the PhoneBook class, specifically the add,
  # delete, and include? methods.  Don't Repeat Yourself.  :-)
  #
  # This is overkill for just three methods, but I wanted to learn some of the
  # more framework-y aspects of Ruby.  I wanted to learn more about Ruby's
  # object model, and use method_missing and object message sending to make a
  # dynamic method dispatcher.  If I understand correctly, Rails uses a similar
  # technique for URL routing/dispatch.
  def method_missing(name, *args, &block)
    if ['add', 'delete', 'include?'].include?(name.to_s)

      # At first, I'd done this:
      #   s = args[0]
      #   s = validate_input(s)
      #   @node.send(name, s)
      #
      # This was problematic, because someone could've called our add, delete,
      # and include? methods with the wrong number of arguments.  As long as
      # the first argument was a string, they wouldn't have even gotten an
      # exception/traceback.
      #
      # The way it's implemented now, people will get the expected
      # exceptions/tracebacks if they call our methods with the wrong number of
      # arguments, or the wrong type of arguments.  This will make someone's
      # middle-of-the-night debugging session much easier (probably mine).  ;-)
      #
      # I spend so much of my life trying to outsmart my past or future self.
      args[0] = validate_input(*args)
      val = @node.send(name, *args)

      val = name.to_s == 'include?' ? val : self
      return val
    else
      return super(name, *args, &block)
    end
  end

  private

  def validate_input(s)
    regex = /^\d{3}-\d{3}-\d{4}$/
    match = s =~ regex
    unless match
      raise ArgumentError, 'phone number must be of form: 713-725-8220'
    end
    s.gsub(/[^0-9]/, '')
  end

  # In terms of the interface, this Node class is identical to the Node class
  # defined in phonebook1.rb.  (The two Node classes are even identical in
  # terms of internal data structures.)  However, the two Node classes differ
  # in implementation/algorithms.  The Node class in phonebook1.rb uses
  # recursion, which is cleaner.  This Node class uses iteration, which is
  # probably more efficient.  (I haven't profiled either implementation; I
  # probably should.)
  class Node

    attr_reader :children

    def initialize
      @children = {}
    end

    def add(s)
      node = self
      while s.any?
        # Get the next digit of the phone number.
        c = s.slice!(0).chr

        # Create a child node corresponding to that digit, if it doesn't
        # already exist.
        node.children[c] = Node.new unless node.children[c]

        # Traverse to that child node.
        node = node.children[c]
      end
      self
    end

    def delete(s)
      # Walk down the tree, saving the path corresponding to the phone number
      # to be deleted.  Iff we're able to fully traverse each digit of the
      # phone number, the phone number exists within our tree.
      node, path, traversed = self, [], true
      while s.any? and node and traversed
        c = s.slice!(0).chr
        traversed = not node.children[c].nil?
        path.push([node, c]) if traversed
        node = node.children[c] if traversed
      end

      # Iff the phone number exists within our tree, walk back up its path,
      # deleting the no longer necessary nodes corresponding to the digits of
      # the phone number.  We have to be careful because the entire point of
      # this data structure is to save memory by sharing nodes between multiple
      # phone numbers.  So we can only delete nodes solely used by the phone
      # number to be deleted (and no other phone numbers).
      if traversed
        path.reverse_each do |node, c|
          kept = node.children[c].children.any?
          node.children.delete(c) unless kept
          break if kept
        end
      end
      self
    end

    def include?(s)
      node = self
      while s.any?
        c = s.slice!(0).chr
        node = node.children[c]
        return false unless node
      end
      true
    end

  end

end
