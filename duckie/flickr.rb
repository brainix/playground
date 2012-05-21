#!/usr/bin/env ruby

#-----------------------------------------------------------------------------#
#   flickr.rb                                                                 #
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

require 'flickraw'



module FLICKR
  API_KEY = '48410dec9118d5fcddb9ce4be1d5e387'
  API_SECRET = '0f1be97a8ec091f6'

  ACCESS_TOKEN = '72157629811083772-7ce62b48f55d76e6'
  ACCESS_SECRET = '8011fd19f6a0c19e'



  module AUTHORIZATION
    def self.authorize
      token, auth_url = get_auth_url
      verifier = verify(auth_url)
      log_in(token, verifier)
    end

    private
    def self.get_auth_url
      FlickRaw.api_key = API_KEY
      FlickRaw.shared_secret = API_SECRET
      token = flickr.get_request_token
      auth_url = flickr.get_authorize_url(token['oauth_token'])
      return token, auth_url
    end

    def self.verify(auth_url)
      puts 'Load: ' + auth_url
      puts 'Authorize Rubber Duckie'
      puts 'Copy/paste the authorization number here:'
      verifier = gets.strip
      verifier
    end

    def self.log_in(token, verifier)
      flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verifier)
      login = flickr.test.login
      puts 'Username: ' + login.username
      puts 'Access token: ' + flickr.access_token
      puts 'Access secret: ' + flickr.access_secret
    end
  end



  module SEARCH
    EXAMPLE_RESULT_URLS = [
      'http://farm7.staticflickr.com/6159/6176523790_5e29bbc181.jpg',
      'http://farm7.staticflickr.com/6160/6176524142_278ee0c7bc.jpg',
      'http://farm7.staticflickr.com/6165/6176524192_4bbd6895b6.jpg',
      'http://farm7.staticflickr.com/6170/6176523674_0280cf96b5.jpg',
      'http://farm7.staticflickr.com/6155/6175995205_076a436445.jpg',
      'http://farm7.staticflickr.com/6176/6175994873_136a7bb549.jpg',
      'http://farm7.staticflickr.com/6153/6175994745_a584fbac13.jpg',
      'http://farm7.staticflickr.com/6177/6175994995_b5848355fc.jpg',
      'http://farm7.staticflickr.com/6172/6175995343_1272b88a14.jpg',
      'http://farm7.staticflickr.com/6175/6176524062_9d83904b2d.jpg',
      'http://farm7.staticflickr.com/6160/6175994947_ff7c613e84.jpg',
      'http://farm7.staticflickr.com/6172/6175995843_70b22082c4.jpg',
      'http://farm7.staticflickr.com/6180/6175995711_58cc9425c2.jpg',
      'http://farm7.staticflickr.com/6161/6176524704_7f7c7fe9a9.jpg',
      'http://farm7.staticflickr.com/6176/6175995639_c950dab663.jpg',
    ]

    @@logger = Logger.new(STDOUT)
    @@logger.level = Logger::DEBUG

    def self.log_in(debug=false)
      if debug
        login = nil
        @@logger.warn('Running in debug mode, not logging in')
      else
        FlickRaw.api_key = API_KEY
        FlickRaw.shared_secret = API_SECRET
        flickr.access_token = ACCESS_TOKEN
        flickr.access_secret = ACCESS_SECRET
        login = flickr.test.login
        @@logger.info('Logged in as: ' + login.username)
      end
      login
    end

    def self.unsafe_search(query, debug=false)
      if debug
        urls = EXAMPLE_RESULT_URLS
        @@logger.warn('Running in debug mode, returning hard-coded example results')
      else
        rated_r = search(query, false)
        @@logger.debug("Rated R search for '#{query}', got #{rated_r.size} results")
        rated_pg13 = search(query, true)
        @@logger.debug("Rated PG-13 search for '#{query}', got #{rated_pg13.size} results")
        rated_r_only = rated_r - rated_pg13
        @@logger.info("Removed Rated PG-13 results from Rated R results, got #{rated_r_only.size} results")
        urls = ids_to_urls(rated_r_only)
      end
      urls
    end

    private
    def self.search(query, safe)
      safe_search = safe ? '2' : '3'
      results = flickr.photos.search(
        text: query,
        sort: 'relevance',
        safe_search: safe_search,
        per_page: '500',
      )

      ids = []
      results.each { |result| ids << result['id'] }
      ids
    end

    def self.ids_to_urls(ids)
      urls = []
      ids.each { |id|
        info = flickr.photos.getInfo(photo_id: id)
        url = FlickRaw.url(info)
        urls << url
      }
      urls
    end
  end
end



if __FILE__ == $0
  query = ARGV.join(' ')
  results = puts FLICKR::SEARCH.unsafe_search(query)
  results urls
end
