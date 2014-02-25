#!/usr/bin/ruby
require 'net/http'
require 'uri'

puts "Type your Bing API Key"
accountKey = gets.chomp

cmmurls = ["https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/Web", "http://schemas.microsoft.com/ado/2007/08/dataservices",
"http://schemas.microsoft.com/ado/2007/08/dataservices/metadata", "http://www.w3.org/2005/Atom", "https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/Web?Query='ip:"]

page = 0
result = 200
count = 0

puts "Type the server IP"
server = gets.chomp

while result == 200

	uri = URI.parse("https://api.datamarket.azure.com/Bing/Search/v1/Web")

	uri.query = [uri.query, "Query=%27ip%3A%20"+server+"%27&Adult=%27Off%27&$skip="+page.to_s()].compact.join('?')

	req = Net::HTTP::Get.new(uri.request_uri)
	req.basic_auth '', accountKey

	res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https'){|http|
		http.request(req)
	}

	count += 100
	page = count
	result = res.code.to_i

	puts page.to_s + " of 5000"

	urls = URI.extract(res.body, ['http', 'https'])

	File.open('result.txt', "w") { |file| file.write(urls) }

	contents = File.open('result.txt', 'r') { |f| f.read }

	conteudo = eval(contents)

	conteudo.each { |x|
		if cmmurls.include?(x)
			conteudo.delete(x
)		else
			File.open('filtered.txt', "a+") do |filt|
				filt.write(x+"\n")
			end
		end
	}

	if count > 5000
		break
	end

end

File.delete("result.txt")

puts "All results saved at filtered.txt"