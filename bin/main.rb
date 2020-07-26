# frozen_string_literal: true

require 'mechanize'
require 'byebug'
require_relative '../lib/raw_page.rb'

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
  tmp_clean_array = remove_empty_product(temp_clean_array)
  clean_array = []
  (tmp_clean_array.length - 1).times do |i|
    clean_array[i] = tmp_clean_array[i].gsub(/[\s,]/, '').to_i
  end
  clean_array
end

def getDetails(array, price)
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
dets_iSh = iShopping_phones_details.split('Samsung')
pre_clean_dets_iSh = remove_empty_product(dets_iSh)
clean_dets_iSh = []
(pre_clean_dets_iSh.length - 1).times do |i|
  clean_dets_iSh[i] = 'Samsung' + pre_clean_dets_iSh[i]
end
iSh_clean_price = clean_price(iShopping_phones_price)
iShopping = getDetails(clean_dets_iSh, iSh_clean_price)
dets_array = hs_dets.split("\n\n\n")
clean_dets = remove_empty_product(dets_array)
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
homeShopping_phones.each do |_info|
  phone_info = {
    model: model[i],
    specs: specs[i],
    warranty: warranty[i],
    price: actual_price[i]
  }
  i += 1
  hs_phones << phone_info
end
