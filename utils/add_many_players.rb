#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'socket'

MY_HOSTNAME = Socket.gethostname

WORKSHOP_URL = "http://#{MY_HOSTNAME}:3000/players"
PLAYER_URL   = "http://#{MY_HOSTNAME}:8088/"
NUMBER_OF_PLAYERS = 30

def add_player(name, url)
  res = Net::HTTP.post_form(URI.parse(WORKSHOP_URL),
    {'name' => name, 'url' => url})
  puts res
end

add_player("separate", "http://#{MY_HOSTNAME}:8089")
#add_player("something different", "http://google.com")

NUMBER_OF_PLAYERS.times do |number|
  add_player("player #{number}", PLAYER_URL)
end
