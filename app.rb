require 'sinatra'
require 'sqlite3'
require 'json'
require 'bcrypt'
STATS = ["Total", "Attack", "Defense", "Strength","Hitpoints", "Ranged", "Prayer", "Magic", "Cooking", "Woodcutting", "Fletching","Fishing", "Firemaking", "Crafting","Smithing","Mining", "Herblore","Agility","Thieving", "Slayer", "Farming", "Runecrafting" ,"Hunter", "Construction"]

set :bind, '192.168.1.89'
enable :sessions
$curruser = nil

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

	if session[:user] != nil && result != nil
		session[:favorites] = id
	end

	db = SQLite3::Database.new('./db/rssite.db')

	followers = db.execute("SELECT COUNT(favorites) FROM UserFavs WHERE LOWER(favorites) LIKE '#{id.downcase}'")[0][0]
	if $curruser != nil
		begin
			followed = db.execute("SELECT favorites FROM UserFavs WHERE LOWER(name) LIKE '#{$curruser.downcase}' AND LOWER(favorites) LIKE '#{id.downcase}'")[0][0]
		rescue
			followed = nil
		end
	else
		followed = nil
	end
	p followed
	erb(:view, locals:{result:result, id:id, stats:STATS, followers:followers, followed:followed})
end

get('/login') do
	erb(:login)
end

get('/favorite/:id') do
	id = params[:id]
	db = SQLite3::Database.new('./db/rssite.db')
	db.execute("INSERT INTO UserFavs (favorites, name) VALUES (LOWER('#{id}'), LOWER('#{$curruser}'))")
	if id.include? " "
		id = id.sub(" ", "%20")
	end
	redirect("/view/#{id}")
end

get('/unfavorite/:id') do
	id = params[:id]
	db = SQLite3::Database.new('./db/rssite.db')
	db.execute("DELETE FROM UserFavs WHERE LOWER(favorites) LIKE '#{id}' AND LOWER(name) LIKE '#{$curruser}'")
	if id.include? " "
		id = id.sub(" ", "%20")
	end
	redirect("/view/#{id}")
end

post('/login_check') do
	username = params[:username]
	password = params[:password]
	db = SQLite3::Database.new('./db/rssite.db')

	usercheck = db.execute("SELECT name FROM Users WHERE LOWER(name) LIKE '#{username.downcase}'")
	passcheck = db.execute("SELECT password FROM Users WHERE LOWER(name) LIKE '#{username.downcase}'")

	begin
		passhash = BCrypt::Password.new(passcheck[0][0])
	rescue
		passhash = nil
	end
	if passhash == password
		session[:user] = params[:username]
		$curruser = session[:user]
		errmsg = "Login Successful as #{$curruser}!"
		redirect = "/"
		erb(:error, locals:{errmsg:errmsg, redirect:redirect})
	else
		errmsg = "Incorrect Username or Password!"
		redirect = "/login"
		erb(:error, locals:{errmsg:errmsg, redirect:redirect})
	end
end

get('/register') do
	erb(:register)
end

post('/register_check') do
	db = SQLite3::Database.new('./db/rssite.db')
	username = params[:username]
	password = params[:password]
	password2 = params[:password2]

	usercheck = db.execute("SELECT name FROM Users WHERE name LIKE '#{username.downcase}'")

	if password != password2
		errmsg = "Passwords must match!"
		redirect = "/register"
		erb(:error, locals:{errmsg:errmsg, redirect:redirect})
	elsif username == nil
		errmsg = "Must enter valid username!"
		redirect = "/register"
		erb(:error, locals:{errmsg:errmsg, redirect:redirect})
	else
		begin
			if usercheck[0][0].downcase == username.downcase
				errmsg = "Must enter valid username!"
				redirect = "/register"
				erb(:error, locals:{errmsg:errmsg, redirect:redirect})
			end
		rescue
			cryptpass = BCrypt::Password.create(password)
			db.execute("INSERT INTO Users(name, password) VALUES('#{username}', '#{cryptpass}')")
			errmsg = "Account has successfully been created!"
			redirect = "/"
			erb(:error, locals:{errmsg:errmsg, redirect:redirect})
		end
	end



end

get('/logout') do
	session.delete(:user)
	session.delete(:favorites)
	$curruser = nil
	redirect('/')
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
	#friend = db.execute("")
	friend = nil
	idcheck = db.execute("SELECT name FROM Users WHERE LOWER(name) LIKE '#{id.downcase}'")
	friends = db.execute("SELECT friend FROM UserFriends WHERE LOWER(name) LIKE '#{id.downcase}'")
	favorites = db.execute("SELECT favorites FROM UserFavs WHERE LOWER(name) LIKE '#{id.downcase}'")

	erb(:profile, locals:{id:idcheck, friends:friends, favorites:favorites, friend:friend})
end


