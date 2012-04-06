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


module Safari
  @app = Appscript.app('Safari')

  def self.get_pages
    tabs, pages = get_tabs, []
    tabs.each do |tab|
      url = tab.URL.get
      page = {
        'url' => url,
        'title' => tab.name.get,
      }
      pages << page
    end
    pages
  end

  private
  def self.get_tabs
    windows, tabs = @app.windows.get, []
    windows.each do |window|
      tabs += window.tabs.get
    end
    tabs
  end
end


if __FILE__ == $0
  pages = Safari.get_pages
  puts pages
end
