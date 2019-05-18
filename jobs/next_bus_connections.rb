require 'rest-client'
require 'active_support/core_ext/hash/conversions'
require 'time'

authKey = "x-x-x-x"
# Turnstraße 3014629
station = "3014573"

SCHEDULER.every '1m', :first_in => 0 do |job|
  puts "next bus connection"

  currentTime = Time.now
  date = currentTime.strftime("%F")
  time = currentTime.strftime("%H:%M")

  depatureRequest = "departureBoard?accessId=#{authKey}&extId=#{station}&date=#{date}&time=#{time}&duration=100"
  url = "https://www.rmv.de/hapi/" + depatureRequest

  response = RestClient.get(url)
  data = Hash.from_xml(response.body)['DepartureBoard']['Departure']

  items = data.map do |b|
    name = "#{b['name']} #{b['direction']}"
    time = Time.strptime(b['date'] + b['time'], "%F%T")
    {name: name, time: time.strftime("%R")}
  end

  send_event('nextBusConnections', { items: items.map { |i| {label: i[:name], value: i[:time]}} })
  # send_event('nextTrainConnections', { items: items.map { |i| {label: "#{i[:name]} #{i[:stationen].last}", value: i[:time].strftime('%H:%M') }}})
end
