require 'sinatra'
require 'sqlite3'
require 'json'

STATS = ["Total: ", "Attack: ", "Defense: ", "Strength: ","Hitpoints: ", "Ranged: ", "Prayer: ", "Magic: ", "Cooking: ", "Woodcutting: ", "Fletching: ","Fishing: ", "Firemaking: ", "Crafting: ","Smithing: ","Mining: ", "Herblore: ","Agility: ","Thieving: ", "Slayer: ", "Farming: ", "Runecrafting: " ,"Hunter: ", "Construction: "]

get('/') do
	erb(:index)
end

get('/view/:id') do
	result = []
	id = params[:id]
	run = `python statnames.py #{id}`
	file = File.open("stats.txt", "r")
	stats = file.read
	stats = JSON.parse(stats)
	file.close
	STATS.each_with_index do |i,x|
		result << i + stats[x].to_s
	end
	erb(:view, locals:{result:result})
end

get('/login') do
end

post('/search') do
	redirect('/view/'+params[:id])
end



