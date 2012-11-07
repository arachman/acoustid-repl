require 'active_record'
module Query
  
  @@db_config ||= YAML::load(File.open("config/database.yml"))
  ActiveRecord::Base.establish_connection(@@db_config)
  @@conn = ActiveRecord::Base.connection

  @@table_lookup = {}

  def initialize
    @table = nil
    @columns = []
    @values = []
    @condition_columns = []
    @condition_values = []
  end

  def set_table(t_name)
    @table = t_name
    self.get_table_properties(t_name) 
  end

  def add_column_value(col_name, col_val)
    @columns << col_name
    @values << sql_value_format(col_name, col_val)
  end

  def add_condition_value(col_name, col_val)
    @condition_columns << col_name
    @condition_values << sql_value_format(col_name, col_val)
  end

  def get_table_properties(table_name)
    if(!(@@table_lookup[table_name].nil?))
      return
    end
    @@table_lookup[table_name] = {}
    @@conn.columns(table_name).each { |col|
      @@table_lookup[table_name][col.name] = col.type
    }
  end

  def sql_value_format(col_name, col_val)
    if(col_val.empty?)
      return 'NULL'
    end
    col_type = @@table_lookup[@table][col_val]
    #TODO check if it's nil 
    if(col_type == :integer)
      return col_val
    else
      return "\'#{col_val}\'"
    end
  end
end
