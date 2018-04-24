require 'sinatra'
require 'sqlite3'
require 'json'

STATS = ["Total", "Attack", "Defense", "Strength","Hitpoints", "Ranged", "Prayer", "Magic", "Cooking", "Woodcutting", "Fletching","Fishing", "Firemaking", "Crafting","Smithing","Mining", "Herblore","Agility","Thieving", "Slayer", "Farming", "Runecrafting" ,"Hunter", "Construction"]

get('/') do
	erb(:index)
end

get('/view/') do
	result = nil
	erb(:view, locals:{result:result})
end

get('/view/:id') do
	result = []
	id = params[:id]
	if id.include? "%20"
		id = id.sub("%20", " ")
	end
	run = `python statnames.py #{id}`
	p run
	file = File.open("stats.txt", "r")
	stats = file.read
	stats = JSON.parse(stats)
	file.close
	if stats[0] == nil
		result = nil
	else 
		STATS.each_with_index do |i,x|
			result << i + ": " + stats[x].to_s
		end
	end
	erb(:view, locals:{result:result, id:id, stats:STATS})
end

get('/login') do
	erb(:login)
end

get('/register') do
	erb(:register)
end

post('/search') do
	id = params[:id]
	if id.include? " "
		id = id.sub(" ", "%20")
	end
	redirect('/view/'+id)
end



