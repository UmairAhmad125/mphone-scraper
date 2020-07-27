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

url = 'https://homeshopping.pk/categories/Samsung-Mobile-Prices-In-Pakistan/'
url_i = 'https://www.ishopping.pk/electronics/mobile-phones-tablet-pc/mobile-phones-prices-in-pakistan/samsung.html'
home_shopping_obj = RawPage.new
home_shopping_obj.url = url
hs_page = home_shopping_obj.raw_page
i_shopping_obj = RawPage.new
i_shopping_obj.url = url_i
i_page = i_shopping_obj.raw_page
home_shopping_phones = hs_page.search('div.product-box')
i_shopping_phones = i_page.search('div.inner-grid')
i_shopping_phones_details = i_shopping_phones.css('h2.product-name a').text.to_s
i_shopping_phones_price = i_shopping_phones.css('span.price').text.to_s
hs_dets = home_shopping_phones.css('div.product-box a').text.to_s
dets_ish = i_shopping_phones_details.split('Samsung')
remove_empty = DeleteNil.new
remove_empty.array = dets_ish
pre_clean_dets_ish = remove_empty.remove_empty_product
clean_dets_ish = []
(pre_clean_dets_ish.length - 1).times do |i|
  clean_dets_ish[i] = 'Samsung' + pre_clean_dets_ish[i]
end
ish_clean_price = clean_price(i_shopping_phones_price)

i_shopping_clean = CleanData.new
i_shopping_clean.array = clean_dets_ish
i_shopping_clean.price = ish_clean_price
i_shopping_products = i_shopping_clean.details
dets_array = hs_dets.split("\n\n\n")
remove_empty_arr = DeleteNil.new
remove_empty_arr.array = dets_array
clean_dets = remove_empty_arr.remove_empty_product
hs_phones_details = CleanData.new
hs_phones_details.array = clean_dets
h_shopping_products = hs_phones_details.details_hs
write_hs = CsvMaker.new
write_hs.array = h_shopping_products
write_hs.write_file_hs
write_is = CsvMaker.new
write_is.array = i_shopping_products
write_is.write_file_is
compare = ComparePrices.new
compare.is_array = i_shopping_products
compare.hs_array = h_shopping_products
comparison_array = compare.compare
puts h_shopping_products
puts
puts i_shopping_products
puts
puts comparison_array
