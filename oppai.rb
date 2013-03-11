# coding: utf-8
require "rubygems"
require "mechanize"
require "nokogiri"
require "open-uri"
require 'kconv'
require "cgi"

keyword =  ARGV[0]
escaped_keyword = CGI.escape(keyword)

a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
}

class Oppai  
#乳値 ＝ （バスト2 - ウエスト）/ 身長
=begin
n＜30   無乳
30≦n＜38    微乳・貧乳
38≦n＜45    普通
45≦n＜55    巨乳
55≦n＜65    爆乳
65≦n    超乳
=end
def initialize(num)
    @num = num
end
def getsize
    if(@num < 30) 
        p '無乳'
    elsif (@num >= 30 && @num < 38) 
        p '微乳・貧乳'
    elsif (@num >= 38 && @num < 45)
        p '普通'
    elsif (@num >= 45 && @num < 55)
        p '巨乳'
    elsif (@num >= 55 && @num < 65)
        p '爆乳'
    elsif (@num >= 65 )
        p '超乳'
    end
end
end

uri = "http://ja.wikipedia.org/wiki/#{escaped_keyword}"
a.get(uri)
a.page.search('table.infobox tr').each do |th,td|

	ar = th.search('th').map{|e| e.inner_text}
	ar.each do |item|
	    if(item == 'スリーサイズ') 
	    o = th.at('td').text.to_s
	    o=o.delete(' ')
	    b= o.split('-')
	    p  'おっぱい' + b[0]+'cm'
	    n = (b[0].to_f*2 - b[1].to_f)
	    n = (n / 172)*100
	    p n
	    o1 = Oppai.new(n)
	    o1.getsize
	    exit
	    end
	end
end
=begin
    search_result = page.form_with(:name => 'gbqf') do |search|
        search.q = q
    end.submit

    search_result.links.each do |link|
        puts link.text
    end
=end

