require './query.rb'
class InsertQuery
  include Query
  def emit_query
    "INSERT INTO #{@table} (#{@columns.join(", ")}) VALUES (#{@values.join(", ")})"
  end
end
