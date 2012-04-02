#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   status2.rb                                                               #
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


require 'appscript'


class Safari
  include Appscript

  def initialize
    @safari = app('Safari')
  end

  def get_urls
    tabs, urls = get_tabs, []
    tabs.each do |tab|
      urls << tab.URL.get
    end
    urls
  end

  private
  def get_tabs
    windows, tabs = @safari.windows.get, []
    windows.each do |window|
      tabs += window.tabs.get
    end
    tabs
  end
end


if __FILE__ == $0
  safari = Safari.new
  urls = safari.get_urls
  puts urls
end
