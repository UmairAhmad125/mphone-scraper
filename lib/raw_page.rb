require 'mechanize'
class RawPage
  attr_writer :url
  def raw_page
    @agent = Mechanize.new
    page = @agent.get(@url)
    page
  end
end
