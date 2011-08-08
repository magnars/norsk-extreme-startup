#!/usr/bin/env ruby

require 'net/http'
require 'uri'

WORKSHOP_URL = "http://localhost:3000/players"
PLAYER_URL   = "http://localhost:8088/"
NUMBER_OF_PLAYERS = 30

NUMBER_OF_PLAYERS.times do |number|
  res = Net::HTTP.post_form(URI.parse(WORKSHOP_URL),
    {'name' => "player #{number}", 'url' => PLAYER_URL})
  puts res
end
