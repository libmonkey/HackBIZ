require 'rest-client'
require 'active_support/core_ext/hash/conversions'

luebeckEva = "8000124"
authKey = "x-x-x-x"

def eventName(label, event)
  if event['l']
    "#{label['c']} #{event['l']}"
  else
    "#{label['c']} #{label['n']}"
  end
end

SCHEDULER.every '3m', :first_in => 0 do |job|
  puts 'next train connection'

  date = Time.now.strftime("%y%m%d")
  hour = Time.now.strftime("%H")
  # TODO hour + 1 ist falsch fuer hour == 23!
  nextHour = (hour.to_i + 1).to_s

  url = "https://api.deutschebahn.com/timetables/v1/plan/#{luebeckEva}/#{date}/#{nextHour}"
  response = RestClient.get(url, headers={"Authorization": "Bearer #{authKey}"})
  data = Hash.from_xml(response.body)['timetable']['s']

  # url = "https://api.deutschebahn.com/timetables/v1/plan/#{luebeckEva}/#{date}/#{nextHour}"
  # response = RestClient.get(url, headers={"Authorization": "Bearer #{authKey}"})
  # data += Hash.from_xml(response.body)['timetable']['s']
  # TODO Verbindungen die um hour ankommen und um nextHour abfahren sind zweimal in data enthalten

  abfahrten = data.select{ |s| s.has_key?('dp') }.sort_by{ |s| s['dp']['pt'] }
  items = abfahrten.map do |s|
    name = eventName(s['tl'], s['dp'])
    time = Time.strptime(s['dp']['pt'], "%y%m%d%H%M")
    stationen = s['dp']['ppth'].split('|')
    {name: name, time: time, stationen: stationen, gleis: s['dp']['pp']}
  end
  items = items.select{ |item| item[:time] > Time.now }

  send_event('nextTrainConnections', { items: items.map { |i| {label: "#{i[:name]} #{i[:stationen].last}", value: i[:time].strftime('%H:%M') }}})
end
