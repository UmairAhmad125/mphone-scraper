class DeleteNil
  attr_writer :array
  def remove_empty_product
    arr = @array
    clean_counter = 0
    clean_arr = []
    while clean_counter < arr.length
      clean_arr[clean_counter] = arr[clean_counter + 1]
      clean_counter += 1
    end
    clean_arr
  end
end
