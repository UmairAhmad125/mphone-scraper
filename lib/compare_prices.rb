# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
require 'byebug'
class ComparePrices
  attr_writer :hs_array
  attr_writer :is_array

  private

  def comparable?(hs_a, is_a)
    chk = false
    i = 0
    while i < 3
      if hs_a[i] == is_a[i]
        chk = true
      else
        chk = false
        return chk
      end
      i += 1
    end
    chk
  end

  def flat_array(hash)
    unless hash.nil?
      values = hash.values
      flat = values[0].split
      converted = flat[2]
    end
    converted
  end

  def compareable(array)
    compareable_array = []
    array.length.times do |i|
      compareable_array[i] = flat_array(array[i])
    end
    compareable_array
  end

  def findunique(final_array, h_array)
    chk = true
    final_array.length.times do |i|
      tmp = final_array[i].values
      array = tmp[0]
      if h_array == array
        chk = false
        return chk
      else
        chk = true
      end
    end
    chk
  end

  public

  def compare
    hs_array = @hs_array
    is_array = @is_array
    hs_compare = compareable(hs_array)
    is_compare = compareable(is_array)
    compare_counter = 0
    final_array = []
    hs_compare.length.times do |i|
      is_compare.length.times do |j|
        next unless comparable?(hs_compare[i], is_compare[j]) && findunique(final_array, hs_array[i])

        compare_counter += 1
        compare_hash = {
          hs: hs_array[i],
          is: is_array[j]
        }
        final_array << compare_hash
      end
    end
    final_array
  end
end
# rubocop:enable Metrics/AbcSize

# rubocop:enable
# rubocop:enable Metrics/MethodLength
