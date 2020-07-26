# frozen_string_literal: true

require 'csv'
require 'byebug'
class CsvMaker
  attr_writer :array
  def write_file_hs
    array = @array
    CSV.open('hs_phones.csv', 'w+') do |csv|
      csv << array[0].keys
      array.length.times do |i|
        csv << array[i].values
      end
    end
  end

  def write_file_is
    array = @array
    CSV.open('is_phones.csv', 'w+') do |csv|
      csv << array[0].keys
      array.length.times do |i|
        csv << array[i].values
      end
    end
  end
end
