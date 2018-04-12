#initialisation avec les trois packages nécessaires
require 'rubygems'
require 'open-uri'
require 'nokogiri'

@array_of_price = [] #initialisation de l'array des prix
@array_of_name = [] #initialisation de l'array des noms de crypto
@result = {} #initialisation du hash final
@compteur = 0  #initialisation du compteur

def coin_market_update
  doc = Nokogiri::HTML(open("https://coinmarketcap.com/")) #initialisation du scrap dans l'URL

  doc.xpath('//a[@class="currency-name-container"]').each do |currency_name| #on récupere les noms de crypto
    @array_of_name << currency_name.text #on stock chaque nom de crypto dans une array contenant des noms
    @compteur += 1 #on ajoute 1 au compteur qui servira a synchroniser les noms des crypto à leurs prix
  end

  doc.xpath('//a[@class="price"]').each do |currency_price| #on récupere les prix des crypto
    @array_of_price <<  currency_price.text #on stock chaque prix de crypto dans une array contenant des prix
  end

  for i in 0 .. @compteur-1 do #on initialise une boucle qui va etre executée le nombre de fois qu'il y a de cryptomonnaies
    @result[@array_of_name[i]]=@array_of_price[i] #on entre dans le hash final chaque nom avec son prix
  end

  puts @result #on affiche le tableau
end

def demarrage
  puts "------Bienvenue!-----"
  puts "Le programme va mettre a jour les cryptomonnaies toutes les heures"
  puts "pour combien d'heures voulez-vous que le programme tourne ? (merci d'exprimer le resultat avec un nombre)"
  nb_repeat = gets.chomp.to_i
  if nb_repeat == 1
    puts "le programme va commencer à récuperer les crypto"
    coin_market_update
    puts "les cryptomonnaies ont été affichées."  
  else
    puts "le programme va commencer à récuperer les crypto et le fera toute les heures pendant #{nb_repeat} heures"
    for n in 0 .. nb_repeat do
      @result = {} #initialisation du hash final
      coin_market_update
      puts "les cryptomonnaies ont été affichées. Prochaine actualisation dans une heure"
      sleep(3600) #Donnée en seconde, soit 1h
    end
  end
end
demarrage