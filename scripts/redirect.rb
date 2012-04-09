#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   redirect.rb                                                              #
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


require 'net/http'


module Redirect
  class Error < StandardError; end
  class InfiniteRedirect < Error; end
  class TooManyRedirects < Error; end

  class Redirect
    def initialize(url)
      @urls = [url]
    end

    def follow
      uri = URI.parse(@urls[-1])
      response = Net::HTTP.get_response(uri)
      if response.kind_of?(Net::HTTPRedirection)
        @urls << response['location']
        detect_infinite_redirects
        response = follow
      end
      response
    end

    private
    def detect_infinite_redirects
      if @urls[0..-2].include?(@urls[-1])
        raise InfiniteRedirect
      end
    end
  end
end


if __FILE__ == $0
  redirect = Redirect::Redirect.new('http://google.com/')
  redirect.follow
end
