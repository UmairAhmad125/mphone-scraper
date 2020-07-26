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
                model[i] = tmp_model.join(' ')
                specs[i] = tmp_spec.join(' ')
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
                model[i] = tmp_model.join(' ')
                specs[i] = tmp_spec.join(' ')
            end

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
end