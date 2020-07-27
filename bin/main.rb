require 'mechanize'
require_relative '../lib/raw_page.rb'
require_relative '../lib/clean_data.rb'
require_relative '../lib/delete_nil.rb'
require_relative '../lib/make_csv.rb'
require_relative '../lib/compare_prices.rb'

def clean_price(array)
  temp_clean_array = array.split('PKR')
  remove_empty = DeleteNil.new
  remove_empty.array = temp_clean_array
  tmp_clean_array = remove_empty.remove_empty_product
  clean_array = []
  (tmp_clean_array.length - 1).times do |i|
    clean_array[i] = tmp_clean_array[i].gsub(/[\s,]/, '').to_i
  end
  clean_array
end

def hs_url
  url = 'https://homeshopping.pk/categories/Samsung-Mobile-Prices-In-Pakistan/'
  home_shopping_obj = RawPage.new
  home_shopping_obj.url = url
  hs_page = home_shopping_obj.raw_page
  hs_page
end

def is_url
  url_i = 'https://www.ishopping.pk/electronics/mobile-phones-tablet-pc/mobile-phones-prices-in-pakistan/samsung.html'
  i_shopping_obj = RawPage.new
  i_shopping_obj.url = url_i
  i_page = i_shopping_obj.raw_page
  i_page
end

def hs_search
  home_shopping_phones = hs_url.search('div.product-box')
  hs_dets = home_shopping_phones.css('div.product-box a').text.to_s
  dets_array = hs_dets.split("\n\n\n")
  dets_array
end

def remove_empty_array(search)
  remove_empty_arr = DeleteNil.new
  remove_empty_arr.array = search
  clean_dets = remove_empty_arr.remove_empty_product
  clean_dets
end

def hs_refined_data
  hs_phones_details = CleanData.new
  hs_phones_details.array = remove_empty_array(hs_search)
  h_shopping_products = hs_phones_details.details_hs
  h_shopping_products
end

def is_search
  i_shopping_phones = is_url.search('div.inner-grid')
  i_shopping_phones_details = i_shopping_phones.css('h2.product-name a').text.to_s
  dets_ish = i_shopping_phones_details.split('Samsung')
  dets_ish
end

def is_pre_refined_data
  pre_clean_dets_ish = remove_empty_array(is_search)
  clean_dets_ish = []
  (pre_clean_dets_ish.length - 1).times do |i|
    clean_dets_ish[i] = 'Samsung' + pre_clean_dets_ish[i]
  end
  clean_dets_ish
end

def is_price
  i_shopping_phones = is_url.search('div.inner-grid')
  i_shopping_phones_price = i_shopping_phones.css('span.price').text.to_s
  ish_clean_price = clean_price(i_shopping_phones_price)
  ish_clean_price
end

def is_refined_data
  i_shopping_clean = CleanData.new
  i_shopping_clean.array = is_pre_refined_data
  i_shopping_clean.price = is_price
  i_shopping_products = i_shopping_clean.details
  i_shopping_products
end

write_hs = CsvMaker.new # write hs_phones in file
write_hs.array = hs_refined_data
write_hs.write_file_hs
write_is = CsvMaker.new # write is_phones in file
write_is.array = is_refined_data
write_is.write_file_is

compare = ComparePrices.new # compare similar phone models
compare.is_array = is_refined_data
compare.hs_array = hs_refined_data
comparison_array = compare.compare

puts hs_refined_data
puts
puts is_refined_data
puts
puts comparison_array
