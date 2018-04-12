require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'watir'

def get_website_incubators(url)
    page = Nokogiri::HTML(open(url))

    zipcode = page.xpath('//td[2]/p/a')
    website = page.xpath('//td[2]/p/span/a')

    register = {}

    #Récupération des infos de la page [nom, code postal, lien menant vers le site de l'incub]
    website.each do |incub|
        infos = []
        infos= [zipcode[website.index(incub)].text, "http://mon-incubateur.com#{website[website.index(incub)]['href']}"]
        page2 = Nokogiri::HTML(open(infos[1]))
        incubator = page2.xpath('//div[2]/div/p[2]/a')
        incubator.each do |incub|
            infos << incub['href']
        end
        register[incub.text] = infos
    end
    register.each do |k,v|
        puts "#{k} = #{v}"
    end
end

PAGE_URL = "http://mon-incubateur.com/site_incubateur/incubateurs"
get_website_incubators(PAGE_URL)