require 'rubygems'
require 'libxml'
require 'ruby-debug'
require './insert_query.rb'
require './update_query.rb'
require './delete_query.rb'

class ReplicationParser
  
  @@type_lookup = {
    "I" => "InsertQuery",
    "U" => "UpdateQuery",
    "D" => "DeleteQuery"
  }

  def initialize(file_path)
    @filename = file_path
  end
  
  def parse
    # take care of nil @file
    doc = LibXML::XML::Document.file(@filename)
    doc.find('//packet/transaction').each do |node|
      puts node['id']
      node.find('event').each do |event|
        op = event['op']
        klass = Object::const_get(@@type_lookup[op])
        query = klass.new()
        query.set_table(event['table'])
        for column in event.find('keys/column').to_a
          col_name = column['name']
          col_val = column.content
          query.add_condition_value(col_name, col_val)
        end
        for column in event.find('values/column').to_a
          col_name = column['name']
          col_val = column.content
          query.add_column_value(col_name, col_val)
        end
        puts query.emit_query
      end
    end
  end
  
  def parse_execute
    # take care of nil @file
    doc = LibXML::XML::Document.file(@filename)
    doc.find('//packet/transaction').each do |node|
      ActiveRecord::Base.transaction do
        puts node['id']
        node.find('event').each do |event|
          op = event['op']
          klass = Object::const_get(@@type_lookup[op])
          query = klass.new()
          query.set_table(event['table'])
          for column in event.find('keys/column').to_a
            col_name = column['name']
            col_val = column.content
            query.add_condition_value(col_name, col_val)
          end
          for column in event.find('values/column').to_a
            col_name = column['name']
            col_val = column.content
            query.add_column_value(col_name, col_val)
          end
          puts query.execute_sql
        end
      end
    end
  end
end

#rp = ReplicationParser.new("acoustid-musicbrainz-update-9621.xml")
#rp.parse_execute
