#!/usr/bin/env ruby

#-----------------------------------------------------------------------------#
#   betteridge.rb                                                             #
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


require 'open-uri'
require 'rss'


FEED = 'http://feeds.foxnews.com/foxnews/latest'
#FEED = 'http://news.google.com/?output=rss'


xml = ''
open(FEED) { |f| xml = f.read }
rss = RSS::Parser.parse(xml, false)


questions = []
rss.items.each { |item| questions << item.title if item.title =~ /^(.*)\?$/ }


tweets = []
questions.each { |question| tweets << question + ' Nope!' }


if __FILE__ == $0
  tweets.each { |tweet| puts tweet }
end
