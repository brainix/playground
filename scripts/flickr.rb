#!/usr/bin/env ruby

#----------------------------------------------------------------------------#
#   flickr.rb                                                                #
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


require 'logger'

require 'flickraw'


module FLICKR
  API_KEY = '48410dec9118d5fcddb9ce4be1d5e387'
  API_SECRET = '0f1be97a8ec091f6'

  ACCESS_TOKEN = '72157629811083772-7ce62b48f55d76e6'
  ACCESS_SECRET = '8011fd19f6a0c19e'

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::DEBUG

  module AUTHORIZATION
    def self.authorize
      token, auth_url = get_auth_url
      verifier = verify(auth_url)
      login(token, verifier)
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
      puts 'Authorize Rubber Duckie.'
      puts 'Copy/paste the authorization number here:'
      verifier = gets.strip
      verifier
    end

    def self.login(token, verifier)
      flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verifier)
      login = flickr.test.login
      puts 'Username: ' + login.username
      puts 'Access token: ' + flickr.access_token
      puts 'Access secret: ' + flickr.access_secret
    end
  end

  def self.unsafe_search(query)
    login
  end

  private
  def self.login
    FlickRaw.api_key = API_KEY
    FlickRaw.shared_secret = API_SECRET
    flickr.access_token = ACCESS_TOKEN
    flickr.access_secret = ACCESS_SECRET
    login = flickr.test.login
    @@logger.debug('logged in as: ' + login.username)
  end
end


if __FILE__ == $0
  puts FLICKR.unsafe_search('nude')
end
