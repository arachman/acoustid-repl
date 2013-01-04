require './repl_downloader.rb'
require './replication_parser.rb'
while(true)
  replication_file = ReplDownloader.download_latest_repl
  if(!replication_file)
    break
  end
  rp = ReplicationParser.new(replication_file)
  rp.parse
  File.delete(replication_file)
end
