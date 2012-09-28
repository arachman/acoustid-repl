module Query
  def initialize
    @table = nil
    @columns = []
    @values = []
    @condition_columns = []
    @condition_values = []
  end

  def set_table(t_name)
    @table = t_name
  end

  def add_column_value(col_name, col_val)
    @columns << col_name
    @values << col_val
  end

  def add_condition_value(col_name, col_val)
    @condition_columns << col_name
    @condition_values << col_val
  end
end
