#!/usr/bin/env ruby

#-----------------------------------------------------------------------------#
#   bing_unsafe_search.rb                                                     #
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


require 'logger'

load 'bing.rb'
load 'timer.rb'


module BingUnsafeSearch
  NUM_PAGES = Bing::NUM_PAGES
  RESULTS_PER_PAGE = Bing::RESULTS_PER_PAGE
  MAX_RESULTS = 100

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  def self.unsafe_search(query)
    threads, rated_r_only = [], []
    time = Timer.time do
      threads = new_threads(query)
      rated_r, rated_pg13 = join_threads(threads)
      rated_r_only = rated_r.reject { |photo| rated_pg13.include? photo }
      rated_r_only = rated_r_only[0 .. MAX_RESULTS - 1]
    end
    @@logger.info("#{query}: got #{rated_r_only.size} Rated R photos in #{'%.2f' % time} seconds")
    rated_r_only
  end

  private

  def self.new_threads(query)
    threads = []
    [false, true].each do |safe|
      0.step((NUM_PAGES - 1) * RESULTS_PER_PAGE, RESULTS_PER_PAGE) do |offset|
        threads << Thread.new do
          Thread.current[:safe] = safe
          Thread.current[:photos] = Bing.search(query, safe, offset)
        end
      end
    end
    threads
  end

  def self.join_threads(threads)
    rated_r, rated_pg13 = [], []
    threads.each do |thread|
      thread.join
      rated_r += thread[:photos] unless thread[:safe]
      rated_pg13 += thread[:photos] if thread[:safe]
    end
    return rated_r, rated_pg13
  end
end


if __FILE__ == $0
  query = ARGV.join(' ')
  photos = BingUnsafeSearch.unsafe_search(query)
  puts photos
end
