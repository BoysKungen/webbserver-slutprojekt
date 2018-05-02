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

post('/register_check') do
	username = params[:username]
	password = params[:password]
	password2 = params[:password2]

	if password != password2
		errmsg = "Passwords must match!"
		redirect = "/register"
		erb(:error, locals:{errmsg:errmsg, redirect:redirect})
	else

	end

end

post('/search') do
	id = params[:id]
	if id.include? " "
		id = id.sub(" ", "%20")
	end
	redirect('/view/'+id)
end

post('/usersearch') do
	id = params[:id]
	if id.include? " "
		id = id.sub(" ", "%20")
	end
	redirect('/user/'+id)
end

get('/user/:id') do
	id = params[:id]
	if id.include? "%20"
		id = id.sub("%20", " ")
	end
	db = SQLite3::Database.new('./db/rssite.db')
	idcheck = db.execute("SELECT name FROM Users WHERE LOWER(name) LIKE '#{id.downcase}'")
	favs = db.execute("SELECT favorites FROM UserFavs WHERE LOWER(name) LIKE '#{id.downcase}'")
	print favs

	erb(:profile, locals:{id:idcheck, favs:favs})
end


