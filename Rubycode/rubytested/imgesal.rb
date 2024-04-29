require 'sinatra'
require 'sqlite3'
require 'sinatra/contrib/all'

# Configuration for public directory and enabling sessions
set :bind, '0.0.0.0'
set :public_folder, 'public'
set :sessions, true

# Connect to SQLite database
DB = SQLite3::Database.new("items.db")

# Create table with the correct schema if it doesn't exist
DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255),
    image_path VARCHAR(255) -- Add the image_path column here
  );
SQL

get '/' do
  @items = DB.execute("SELECT * FROM items")
  erb :index, locals: { items: @items }
end

# Route to handle file uploads
post '/items' do
  name = params[:name]
  if params[:image] && (tempfile = params[:image][:tempfile]) && (filename = params[:image][:filename])
    # Ensure the directory exists
    FileUtils.mkdir_p('public/images')

    # Construct the file path
    path = File.join('public/images', filename)
    File.open(path, 'wb') { |f| f.write(tempfile.read) }
    image_path = File.join('images', filename)
    DB.execute("INSERT INTO items (name, image_path) VALUES (?, ?)", [name, image_path])
  end
  redirect '/'
end

# Route to delete items
delete '/items/:id' do
  id = params[:id]
  # Delete item from database
  DB.execute("DELETE FROM items WHERE id = ?", id)
  redirect '/'
end
