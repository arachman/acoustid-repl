require 'rubygems'
require 'libxml'
require 'ruby-debug'
require './insert_query.rb'
require './update_query.rb'

class ReplicationParser
  
  @@type_lookup = {
    "I" => "InsertQuery",
    "U" => "UpdateQuery"
  }

  def initialize(file_path)
    @filename = file_path
  end
  
  def parse
    # take care of nil @file
    doc = LibXML::XML::Document.file(@filename)
    doc.find('//packet/transaction').each do |node|
      puts node['id']
      event = node.find('event').to_a.first
      op = event['op']
      klass = Object::const_get(@@type_lookup[op])
      query = klass.new()
      query.set_table(event['table'])
       # (node.find('event').to_a.first)['table'])
      for column in node.find('event/keys/column').to_a
        col_name = column['name']
        col_val = column.content
        query.add_condition_value(col_name, col_val)
      end
      
      for column in node.find('event/values/column').to_a
        col_name = column['name']
        col_val = column.content
        query.add_column_value(col_name, col_val)
      end
      
      puts query.emit_query
    end
  end
end

