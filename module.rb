module RssiteDB
	DB_PATH = './db/rssite.db'

	def db_connect
		db = SQLite3::Database.new(DB_PATH)
		return db
	end
end
end