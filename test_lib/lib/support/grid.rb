# grid.rb -r method grid rows, cols



# grid rows, cols - empty array of arrays
def grid rows, cols, &blk
  output = [([nil] * cols)] * rows

  if block_given?
    output.map {|row| row.map {|col| yield } }
  else
    output
  end
end


# enumerated_grid r,c - creates an arrayof arrays with r inner arrays of c elements each
# each inner element is enumerated from 1 .. (rowxcol)
def enumerated_grid rows, cols
  num = 0
  grid(rows, cols) { num += 1 }
end
