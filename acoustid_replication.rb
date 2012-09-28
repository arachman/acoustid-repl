require 'net/http'

Net::HTTP.start("data.acoustid.org") do |http|
  resp = http.get("/replication/acoustid-musicbrainz-update-4511.xml.bz2") 
  open("acoustid-musicbrainz-update-4511.xml.bz2", "wb") do |file|
    file.write(resp.body)
  end
end
puts "Done"
