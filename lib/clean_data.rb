# frozen_string_literal: true

require 'byebug'
class CleanData
  attr_writer :array
  attr_writer :price
  def get_details
    array = @array
    price = @price
    i = 0
    separated = {}
    model = []
    specs = []
    phone_details = []
    while i < array.length
      temp_array = array[i].split('-')
      tmp_array = temp_array[0]
      warranty = temp_array[1]
      spec_array = tmp_array.split(/ /)
      chk_fourth = spec_array[3]
      tmp_model = []
      tmp_spec = []
      if chk_fourth.length > 2 && chk_fourth[3].class == String
        j = 0
        while j < 3
          tmp_model[j] = spec_array[j]
          j += 1
        end
        while j < spec_array.length
          tmp_spec[j - 3] = spec_array[j]
          j += 1
        end

      else
        j = 0
        while j < 4
          tmp_model[j] = spec_array[j]
          j += 1
        end
        while j < spec_array.length
          tmp_spec[j - 4] = spec_array[j]
          j += 1
        end
      end
      model[i] = tmp_model.join(' ')
      specs[i] = tmp_spec.join(' ')
      separated = {
        model: model[i],
        specs: specs[i],
        warranty: warranty.to_s.strip,
        price: price[i]
      }
      phone_details << separated
      i += 1
    end
    phone_details
  end
  def get_details_hs
    clean_dets = @array
    clean_counter = 0
    actual_details = []
    actual_price = []
    model = []
    specs = []
    warranty = []
    while clean_counter < clean_dets.length - 1
        temp_arr = clean_dets[clean_counter].split('Rs')
        actual_details[clean_counter] = temp_arr[0].strip
        temp_model = actual_details[clean_counter].split('(')
        model[clean_counter] = temp_model[0].strip
        temp_specs = temp_model[1].split(')')
        specs[clean_counter] = temp_specs[0].strip
        warranty[clean_counter] = temp_specs[1].strip
        actual_price[clean_counter] = temp_arr[1].gsub(/[\s,]/, '').to_i
        clean_counter += 1
    end
    hs_phones = []
    i = 0
    (clean_dets.length-1).times do |i|
    phone_info = {
        model: model[i],
        specs: specs[i],
        warranty: warranty[i],
        price: actual_price[i]
    }
    i += 1
    hs_phones << phone_info
    end
    hs_phones
  end
  
end
