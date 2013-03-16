# coding: utf-8
require "open-uri"
require "kconv"
require "rubygems"
require "mechanize"
require "time"
require "nokogiri"

def contens(page)
  title = page.at('h3//a').inner_text
  date = page.at('span.date').inner_text
  time = Time.parse date
  date_str = time.year.to_s + "/" + time.month.to_s + "/" + time.day.to_s + " " + time.hour.to_s + ":"+time.min.to_s + "\n"
  contents = page.at('div.contents').inner_text
  body = ""
  body += title
  body += date_str
  contents.split.each do | str |
    if str == '<!--'
      break
    end
  body += str.to_s
  end
  return body
end

body = ''
if ARGV[0]
  ameblo_id =  ARGV[0]
  a = Mechanize.new
  uri = "http://ameblo.jp/#{ameblo_id}/"
  count = 0
  a.get(uri) do |ameblo_page|
    page_count = 1
    paging_links = ameblo_page.at('div.topPaging').search('a')
    last_page_link =  paging_links.find_all{|e| e['class'] == 'lastPage'}.map{|e| e['href'] }
    last_page_num = last_page_link[0].to_s.split('/').last.split('-')[1].to_s.split('.')[0].to_i
    i = 0
    while i < last_page_num
      uri =  "http://ameblo.jp/#{ameblo_id}/page-" + i.to_s + ".html"
      sleep(3)
      begin
      a.get(uri) do  |page|
        #contens(page)
        date = page.at('span.date').inner_text
        time = Time.parse date
        date_str = time.year.to_s + "/" + time.month.to_s + "/" + time.day.to_s + " " + time.hour.to_s + ":"+time.min.to_s + "\n" 

        contents = page.at('div.contents').inner_text

        body += page.at('h3//a').inner_text
        body += date_str
        contents.split.each do | str |
          if str == '<!--'
            break
          end
          body += str.to_s
        end
        imgs = page.at('div.contents').search('img').find_all{|e| e['src'] =~ /(?:.*jpg)/i && e['width'] == nil }.map{|e| e['src']}  
        f = 0
        imgs.each do | e |
          paths = e.split('/')
          o = "o" + paths.last.split('_').last
          file = e.to_s.sub(paths.last,o)
          a.get(file).save
          body += file + ','
        #savefile = "/User/miruku/dir/#{ameblo_id}-#{f}.jpg"
        #p savefile
        #a.get(file).save_as(savefile) #オリジナル画像保存   
          f += 1
        end
        i+=1
      end #end get page  
      rescue Mechanize::ResponseCodeError => ex
        p "だめだた\n"
        #print ex.message, "\n"
      end #end begin
    end #while
  end #end 
  file_name = "#{ameblo_id}.txt"
  File.open(file_name, 'a') {|file|
    file.write(body)
  }
end #end if
=begin
=end
