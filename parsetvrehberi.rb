#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'curb'
require 'date'
require 'mysql2'

client = Mysql2::Client.new(:host => "localhost", :database => 'tvrehberi', :username => "root", :password => "")

client.query("SET NAMES UTF8")


DateTime.now.new_offset(+3)
todaystring = DateTime.now.strftime('%d.%m.%Y')
dbtodaystring = DateTime.now.strftime('%Y-%m-%d')
tvlink = "http://tvrehberi.hurriyet.com.tr"

c = Curl::Easy.new(tvlink) do |curl|
  curl.headers["User-Agent"] = "User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:28.0) Gecko/20100101 Firefox/28.0"
  curl.verbose = false
end

c.http_get
web_page = c.body_str

# Fetch and parse HTML document
doc = Nokogiri::HTML(web_page)

doc.css('li.ChannelLogo').each do |link|
  canallink = link.at_css("a")['href']
  canalname = link.at_css("img")['title'].strip
  canalname.slice! "yayın akışı"
  canalid = link.at_css("a")['id'].scan(/\d+/).first
  canalslug = canalname.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  puts ">"*50   # seperator
  puts "canal name: "+canalname
  puts "date: "+todaystring
  puts "canal id: "+canalid
  puts "canal slugify: "+canalslug

  timelink = tvlink+"/zaman-akisi/"+todaystring
  puts "http://tvrehberi.hurriyet.com.tr"+canallink
    c = Curl::Easy.new(timelink) do |curl|
      curl.follow_location = true
      curl.headers["User-Agent"] = "User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:28.0) Gecko/20100101 Firefox/28.0"
      curl.headers["Referer"] = tvlink+canallink
      curl.headers["Location"] = tvlink+canallink
      curl.headers["Content-Type"] = "text/html; charset=windows-1254"
      curl.verbose = false
    end
    c.http_get
    web_page = c.body_str

    # Fetch and parse HTML document
    doc = Nokogiri::HTML(web_page)

    doc.css('li.ProgramFilmExpanded').each do |plink|
        pstarttime = plink.css("div").first.text.strip
        pname = plink.css("div.TimelineName").text.strip.encode('UTF-8')
        pdesc = plink.css("div.TimelineSummary").text.strip.encode('UTF-8')
        pimage = plink.css("div.image").at_css('img')['src']
        puts "-"*15     #seperator
        puts pname
        puts pstarttime
        puts pdesc
        puts pimage
        pname = client.escape(pname)
        pdesc = client.escape(pdesc)
        insertquery = "INSERT INTO yayinlar_hurriyet (`id`, `name`, `channelname`, `schannelname`, `catname`, `typename`, `startdate`, `day`, `image`, `pdesc`, `channelid`, `udate`, `sdelete`, `timeline`, `weblink`)
        VALUES (NULL, '#{pname}', '#{canalname}', '#{canalslug}', '', NULL, '#{pstarttime}', '#{dbtodaystring}', '#{pimage}', '#{pdesc}', '#{canalid}', CURRENT_TIMESTAMP, '0', '', '')"
        client.query(insertquery)
    end

end
