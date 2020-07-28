# rubocop:disable Layout/LineLength
require_relative '../lib/clean_data'
require_relative '../lib/compare_prices'
require_relative '../lib/delete_nil'
require_relative '../lib/csv_maker'
require_relative '../lib/raw_page'
require 'mechanize'

describe 'CleanData' do
  let(:hs_obj) { CleanData.new }
  let(:is_obj) { CleanData.new }
  let(:hs_array) { ['Samsung Galaxy Note 10 Plus Dual Sim (4G, 12GB RAM, 256 ROM,Aura Black) With Official Warranty  Rs 182,999', 'Samsung Galaxy A31 (4G, 4GB, 128GB, Blue) With Official Warranty Rs 40,199'] }
  let(:is_array) { ['Samsung Galaxy A10s 32GB Dual Sim Red - Official Warranty', 'Samsung Galaxy A10s 32GB Dual Sim Black - Official Warranty'] }
  let(:is_price) { [1_312_312, 3_123_213] }
  describe 'details_hs' do
    it 'should creturn array of hash' do
      hs_obj.array = hs_array
      hashed_array = hs_obj.details_hs
      expect(hashed_array[0].class).to eq(Hash)
    end
  end

  describe 'details' do
    it 'should creturn array of hash' do
      is_obj.array = is_array
      is_obj.price = is_price
      hashed_array = is_obj.details
      expect(hashed_array[0].class).to eq(Hash)
    end
  end
end

describe 'ComparePrices' do
  let(:comp_obj) { ComparePrices.new }
  describe 'details' do
    let(:is_array) { [{ model: 'Samsung Galaxy A10s', specs: '32GB Dual Sim Red', warranty: 'Official Warranty', price: 18_500 }, { model: 'Samsung Galaxy A10s', specs: '32GB Dual Sim Black', warranty: 'Official Warranty', price: 18_500 }] }
    let(:hs_array) { [{ model: 'Samsung Galaxy Note 10 Plus Dual Sim', specs: '4G, 12GB RAM, 256 ROM,Aura Black', warranty: 'With Official Warranty', price: 182_999 }, { model: 'Samsung Galaxy A31', specs: '4G, 4GB, 128GB, Blue', warranty: 'With Official Warranty', price: 40_199 }] }
    it 'should return array of 0 length if phones are not of same model' do
      comp_obj.hs_array = hs_array
      comp_obj.is_array = is_array
      hashed_array = comp_obj.compare
      expect(hashed_array.length).to be(0)
    end
    it 'should return array of containing phone details if phone models match' do
      comp_obj.hs_array = is_array
      comp_obj.is_array = is_array
      hashed_array = comp_obj.compare
      expect(hashed_array.length).to be(2)
    end
    it 'should return array of containing phone details if phone models match' do
      comp_obj.hs_array = is_array
      comp_obj.is_array = is_array
      hashed_array = comp_obj.compare
      expect(hashed_array[0].class).to be(Hash)
    end
  end
end

describe 'DeleteNil' do
  let(:array) { [1, 2, 3] }
  let(:obj) { DeleteNil.new }
  describe 'remove_empty_product' do
    it 'should remove the first element from array and replace last with nil' do
      obj.array = array
      aray = obj.remove_empty_product
      expect(aray).to eq([2, 3, nil])
    end
  end
end

describe 'CsvMaker' do
  let(:is_array) { [{ model: 'Samsung Galaxy A10s', specs: '32GB Dual Sim Red', warranty: 'Official Warranty', price: 18_500 }, { model: 'Samsung Galaxy A10s', specs: '32GB Dual Sim Black', warranty: 'Official Warranty', price: 18_500 }] }
  let(:hs_array) { [{ model: 'Samsung Galaxy Note 10 Plus Dual Sim', specs: '4G, 12GB RAM, 256 ROM,Aura Black', warranty: 'With Official Warranty', price: 182_999 }, { model: 'Samsung Galaxy A31', specs: '4G, 4GB, 128GB, Blue', warranty: 'With Official Warranty', price: 40_199 }] }
  let(:obj) { CsvMaker.new }
  describe 'write_file_hs' do
    it 'should write given data in hs_phones.csv file' do
      obj.array = hs_array
      obj.write_file_hs
      expect(File.file?('hs_phones.csv')).to be(true)
    end
  end
  describe 'write_file_is' do
    it 'should write given data in is_phones.csv file' do
      obj.array = is_array
      obj.write_file_is
      expect(File.file?('is_phones.csv')).to be(true)
    end
  end
end

describe 'RawPage' do
  describe 'raw_page' do
    let(:url) { 'https://vimeo.com/ondemand/jorgemasvidal' }
    agent = Mechanize.new
    let(:raw_obj) { RawPage.new }
    it 'should return raw page' do
      test_page = agent.get(url)
      raw_obj.url = url
      page = raw_obj.raw_page
      expect(page.title).to eq(test_page.title)
    end
  end
end

# rubocop:enable Layout/LineLength
