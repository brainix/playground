#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   phonetree.rb                                                             #
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


class PhoneTree

  def initialize
    @node = Node.new
  end

  def insert(s)
    @node.insert(s)
  end

  def find(s)
    @node.find(s)
  end

  def delete(s)
    @node.delete(s)
  end

  private

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
