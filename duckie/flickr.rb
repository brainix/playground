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



module Flickr
  API_KEY = '48410dec9118d5fcddb9ce4be1d5e387'
  API_SECRET = '0f1be97a8ec091f6'

  ACCESS_TOKEN = '72157629811083772-7ce62b48f55d76e6'
  ACCESS_SECRET = '8011fd19f6a0c19e'



  module Authorization
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
      puts '1. Load: ' + auth_url
      puts '2. Authorize Rubber Duckie'
      puts '3. Copy/paste the authorization number here:'
      verifier = gets.strip
      verifier
    end

    def self.log_in(token, verifier)
      oauth_token = token['oauth_token']
      oauth_token_secret = token['oauth_token_secret']
      flickr.get_access_token(oauth_token, oauth_token_secret, verifier)
      login = flickr.test.login
      puts 'Username: ' + login.username
      puts 'Access token: ' + flickr.access_token
      puts 'Access secret: ' + flickr.access_secret
    end
  end



  module Search
    MPAA_RATING_TO_FLICKR_SAFE_SEARCH_VALUE = {
      rated_pg: '1',
      rated_pg13: '2',
      rated_r: '3',
    }

    MAX_RESULTS = 50

    @@logger = Logger.new(STDOUT)
    @@logger.level = Logger::INFO

    def self.log_in
      FlickRaw.api_key = API_KEY
      FlickRaw.shared_secret = API_SECRET
      flickr.access_token = ACCESS_TOKEN
      flickr.access_secret = ACCESS_SECRET
      login = flickr.test.login
      login
    end

    def self.unsafe_search(query)
      threads, rated_r, rated_pg13, rated_pg = [], [], [], []
      ['rated_r', 'rated_pg13', 'rated_pg'].each do |rating|
        threads << Thread.new do
          eval("#{rating} = search(query, '#{rating}'.to_sym)")
        end
      end
      threads.each { |thread| thread.join }

      rated_r_only = rated_r - rated_pg13
      rated_pg13_only = rated_pg13 - rated_pg
      results = rated_r_only + rated_pg13_only
      @@logger.info("#{query}: got #{rated_r_only.size} Rated R and #{rated_pg13_only.size} Rated PG-13 photos")
      results = results[0 .. MAX_RESULTS - 1]
      results = ids_to_urls(results)
      results.map! { |result| { thumbnail: result, full_size: result } }
      results
    end

    private
    def self.search(query, mpaa_rating)
      results = flickr.photos.search(
        text: query,
        sort: 'relevance',
        safe_search: MPAA_RATING_TO_FLICKR_SAFE_SEARCH_VALUE[mpaa_rating],
        per_page: '500',
      )
      ids = results.map { |result| result['id'] }
      ids
    end

    def self.ids_to_urls(ids)
      threads, urls = [], []
      (0 .. ids.size - 1).each do |index|
        threads << Thread.new do
          info = flickr.photos.getInfo(photo_id: ids[index])
          url = FlickRaw.url(info)
          Thread.current[:output] = url
        end
      end
      threads.each do |thread|
        thread.join
        urls << thread[:output]
      end
      urls
    end
  end
end



if __FILE__ == $0
  query = ARGV.join(' ')
  Flickr::Search.log_in
  photos = puts Flickr::Search.unsafe_search(query)
  photos
end
