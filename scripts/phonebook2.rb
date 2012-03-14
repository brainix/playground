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

  def method_missing(name, *args, &block)
    if ['add', 'delete', 'include?'].include?(name.to_s)
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

  class Node

    attr_reader :children

    def initialize
      @children = {}
    end

    def add(s)
      node = self
      while s.any?
        c = s.slice!(0).chr
        node.children[c] = Node.new unless node.children[c]
        node = node.children[c]
      end
      self
    end

    def delete(s)
      node, nodes, traversed = self, [], true
      while s.any? and node and traversed
        c = s.slice!(0).chr
        traversed = not node.children[c].nil?
        nodes.push([node, c]) if traversed
        node = node.children[c] if traversed
      end

      if traversed
        nodes.reverse_each do |node, c|
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
