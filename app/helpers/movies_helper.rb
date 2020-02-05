module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ? 'odd' : 'even'
  end

  # Sorts the movies by column:
  def sortable(column)
    link_to column.titleize, sort: column
  end
end
