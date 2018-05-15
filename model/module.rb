module rssite
	DB_PATH = './db/rssite.db'


	def db_connect
		return SQLite3::Database.new(DB_PATH)
	end