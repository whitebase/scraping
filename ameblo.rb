# coding: utf-8
require "open-uri"
require "kconv"
require "rubygems"
require "mechanize"
require "time"

ameblo_id =  ARGV[0]
a = Mechanize.new
uri = "http://ameblo.jp/#{ameblo_id}/"
a.get(uri) do |ameblo_page|
    entries = ameblo_page.at('div#recent_entries//ul')
    entries.search('li').each do | li |
        page = li.at('a')['href']
        a.get(page) do | page |
            date = page.at('span.date').inner_text
            time = Time.parse date
            date_str = time.year.to_s + "/" + time.month.to_s + "/" + time.day.to_s + " " + time.hour.to_s + ":"+time.min.to_s + "\n" 
            print( date_str ) #投稿日付
            contents = page.at('div.contents').inner_text
            contents.split.each do | str |
                if str == '<!--'
                    break
                end
                print( str )
            end
            puts "----"
              imgs = page.at('div.contents').search('img').find_all{|e| e['src'] =~ /(?:.*jpg)/i && e['width'] == nil }.map{|e| e['src']}
            imgs.each do | e |
                paths = e.split('/')
                o = "o" + paths.last.split('_').last
                file = e.to_s.sub(paths.last,o)
                print( file )
                a.get(file).save #オリジナル画像保存
            end
        end
        puts "\n----"
    end
end
=begin
=end
