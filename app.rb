require 'sinatra'
require 'sqlite3'

get('/') do
	erb(:index)
end

get('/view/:id') do

	id = params[:id]	
	erb(:view, locals:{result:result})
end

get('/login') do
end

post('/search') do
	db = SQLite3::Database.new("./db/rssite.db")
	id = params[:id]
	redirect('/view/'+id)
end



