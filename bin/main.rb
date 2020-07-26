# frozen_string_literal: true

require 'mechanize'
require 'byebug'
require_relative '../lib/raw_page.rb'
require_relative '../lib/clean_data.rb'
require_relative '../lib/delete_nil.rb'

def remove_empty_product(arr)
  clean_counter = 0
  clean_arr = []
  while clean_counter < arr.length
    clean_arr[clean_counter] = arr[clean_counter + 1]
    clean_counter += 1
  end
  clean_arr
end

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

url = 'https://homeshopping.pk/categories/Samsung-Mobile-Prices-In-Pakistan/'
url_i = 'https://www.ishopping.pk/electronics/mobile-phones-tablet-pc/mobile-phones-prices-in-pakistan/samsung.html'
home_shopping_obj = RawPage.new
home_shopping_obj.url = url
hs_page = home_shopping_obj.raw_page
i_shopping_obj = RawPage.new
i_shopping_obj.url = url_i
i_page = i_shopping_obj.raw_page
homeShopping_phones = hs_page.search('div.product-box')
iShopping_phones = i_page.search('div.inner-grid')
iShopping_phones_details = iShopping_phones.css('h2.product-name a').text.to_s
iShopping_phones_price = iShopping_phones.css('span.price').text.to_s
hs_dets =  homeShopping_phones.css('div.product-box a').text.to_s
dets_ish = iShopping_phones_details.split('Samsung')
remove_empty = DeleteNil.new
remove_empty.array = dets_ish
pre_clean_dets_ish = remove_empty.remove_empty_product
clean_dets_ish = []
(pre_clean_dets_ish.length - 1).times do |i|
  clean_dets_ish[i] = 'Samsung' + pre_clean_dets_ish[i]
end
ish_clean_price = clean_price(iShopping_phones_price)

i_shopping_clean = CleanData.new
i_shopping_clean.array = clean_dets_ish
i_shopping_clean.price = ish_clean_price
i_shopping_products = i_shopping_clean.get_details
dets_array = hs_dets.split("\n\n\n")
remove_empty_arr = DeleteNil.new
remove_empty_arr.array = dets_array
clean_dets = remove_empty_arr.remove_empty_product
hs_phones_details = CleanData.new
hs_phones_details.array = clean_dets
h_shopping_products = hs_phones_details.get_details_hs
puts h_shopping_products