#!/usr/bin/ruby
require 'net/http'
require 'json'

api_key = '7f40dd4d0b3b54e0'

# Default Values
options = {features: ['conditions'], settings: ['lang:EN'], query: ['autoip'], format: ['json']}


OPTIONS = {
  features: ['alerts', 'almanac', 'astronomy', 'conditions', 'currenthurricane', 'forecast', 'forecast10day', 'geolookup', 'history', 'hourly', 'hourly10day', 'planner', 'rawtide', 'tide', 'webcams', 'yesterday'], 
  settings: ['lang', 'pws', 'bestfct'], 
  query: ['state/city', 'zipcode', 'country/city', 'lat,long', 'airport', 'PWS', 'autoip', 'IP'],
  format: ['json', 'xml']
}

def get_weather(api_key, options)
  base_url = 'http://api.wunderground.com/api'
  url = "#{base_url}/#{api_key}/#{options[:features].join('/')}/#{options[:settings].join('/')}/q/#{options[:query].join('/')}.#{options[:format].join('/')}"

  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body

  result = JSON.parse(data)

  if result.has_key? 'Error'
    raise "web service error"
  end
  return result
end

ARGV.each { |argument|
  if OPTIONS[:features].include?(argument)
    options[:features] << argument
  elsif OPTIONS[:settings].include?(argument)
    options[:settings] << argument
  elsif OPTIONS[:query].include?(argument)
    options[:query] = ['49931']
  elsif OPTIONS[:format].include?(argument)
    options[:format] = [argument]
  else
    raise SyntaxError, "#{argument} is not a valid option"
  end
}


weather = get_weather(api_key, options)
if options[:features].include?('forecast')
  puts "#{weather["forecast"]["simpleforecast"]["forecastday"][0]["conditions"]}: #{weather["forecast"]["simpleforecast"]["forecastday"][0]["high"]["fahrenheit"]} F"
end
