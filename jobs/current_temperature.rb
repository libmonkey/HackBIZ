require 'net/http'
require 'json'
require 'time'
require 'date'
require 'active_support'
require 'active_support/core_ext'

currentw = '/data/2.5/weather?zip=35396,de&APPID=40b444314a3c9c428082a610351ea2cb&units=metric'

SCHEDULER.every '30s', :first_in => 0 do |job|
  puts 'Get weather'
  http = Net::HTTP.new('api.openweathermap.org', 80)
  currentresult = http.request(Net::HTTP::Get.new(currentw))
  currentjson = JSON.parse(currentresult.body)

  temperature = currentjson['main']['temp']

  send_event('temperatur', {current: temperature})
end
