require 'open-uri'
require 'bzip2'

class ReplDownloader

  @@sequence = -1
  @@url = "http://data.acoustid.org/"
  @@file_path ="/replication/"
  @@file_name = "acoustid-musicbrainz-update-"
  @@ext = ".xml.bz2"
  
  def self.download_latest_repl
    download_file_name = next_version_file_name
    begin
      open( "#{@@url}#{@@file_path}#{download_file_name}" , 'rb') do |update|
        File.open("#{next_version_file_name}", 'wb') do |file|
          file.write(update.read)
        end
      end
      update_version_file
    rescue OpenURI::HTTPError => e
      download_file_name = nil
      return
    end
    xml_f = File.open(download_file_name.gsub(/\.bz2/, ''), 'wb')
    Bzip2::Reader.open(download_file_name) { |bz2_f|
      xml_f.write(bz2_f.read)
    }
    xml_f.close
    File.delete(download_file_name)
    download_file_name.gsub(/\.bz2/, '')
  end

  def self.get_next_version
    File.open("replication_sequence", "r")  do |file|
      begin
        @@sequence = file.gets.to_i + 1
      rescue
        @@sequence = -1
      ensure 
        file.close unless file.nil?
      end
    end
    @@sequence
  end

  def self.next_version_file_name
    "#{@@file_name}#{get_next_version}#{@@ext}"
  end

  def self.update_version_file
    if @@sequence == -1
      puts  "Version file has not been loaded. Please get next version " +
            "before updating the version file"
      return
    end
    File.open("replication_sequence", "w")  do |file|
      begin
        file.puts "#{@@sequence}"
      rescue
        puts "Something went wrong"
      ensure 
        file.close unless file.nil?
      end
    end
    @@sequence
  end
end

