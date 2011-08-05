#!/usr/bin/env ruby
# google.rb

# Copyright (c) 2011
#      Paul L. Snyder (paul@pataprogramming.com)
#
# This file is part of Consolation.
#
# Consolation is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Consolation is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'uri'

search=URI.escape(ARGV.join(" "))

uri=URI.escape("http://www.google.com/search?hl=en&q=" + search)
#puts(uri)
#puts

headers = {
  "User-Agent"=> 
    "Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20100101 Firefox/5.0",
  "Accept-Charset"=>"utf-8",
  "Accept"=>"text/html"
}

raw_html = ""
open(uri, headers).each {|s| raw_html << s}

hobj = Hpricot(raw_html)
results = []

hobj.search("div[@class*=vsc]").each {
  |e| res = {}
      tmp = e.at("h3[@class*=r]/a")
      res['link'] = tmp.get_attribute("href")
      res['title'] = tmp.to_plain_text
      res['excerpt'] = e.at("span[@class*=st]").to_plain_text
      results.push(res)
}

results.each{ |r| puts(r['link']) }
