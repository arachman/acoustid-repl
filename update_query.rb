require './query.rb'
class UpdateQuery
  include Query
  def emit_query
    
    col_val_pair = []
    cond_col_val_pair = []
    @columns.zip(@values).each { |tuple|
      col_val_pair << tuple.join(" = ")
    }
    @condition_columns.zip(@condition_values).each { |tuple|
      cond_col_val_pair << tuple.join(" = ")
    }
    
    "UPDATE #{@table} SET #{col_val_pair.join(", ")} WHERE #{cond_col_val_pair.join(" AND ")}"
  end
end
