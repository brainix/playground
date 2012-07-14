#!/usr/bin/env ruby

#-----------------------------------------------------------------------------#
#   redirect.rb                                                               #
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
require 'net/http'


module Redirect
  DEFAULT_HTTP_REDIRECT_LIMIT = 20

  class Error < StandardError; end
  class RedirectLoop < Error; end
  class TooManyRedirects < Error; end

  def self.follow(url, limit=DEFAULT_HTTP_REDIRECT_LIMIT)
    redirect = Redirect.new(url, limit=limit)
    redirect.follow
  end

  class Redirect
    @@logger = Logger.new(STDOUT)
    @@logger.level = Logger::DEBUG

    def initialize(url, limit=DEFAULT_HTTP_REDIRECT_LIMIT)
      @urls = [url]
      @limit = limit
    end

    def follow
      @@logger.debug('resolving ' + @urls[-1])
      uri = URI.parse(@urls[-1])
      response = Net::HTTP.get_response(uri)
      if response.kind_of?(Net::HTTPRedirection)
        @urls << response['location']
        @@logger.info(@urls[-2] + ' redirected to ' + @urls[-1])
        detect_loop
        @@logger.debug('%d redirects remaining' % @limit)
        response = follow
      end
      response
    end

    private
    def detect_loop
      raise RedirectLoop if @urls[0..-2].include?(@urls[-1])
      raise TooManyRedirects if (@limit -= 1) <= 0
    end
  end
end


if __FILE__ == $0
  Redirect::follow('http://google.com/')
end
