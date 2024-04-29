require 'sinatra'
require 'sqlite3'
set :bind, '0.0.0.0'
# Connect to SQLite database
DB = SQLite3::Database.new("items.db")

# Create table if not exists
DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255)
  );
SQL

get '/' do
  @items = DB.execute("SELECT * FROM items")
  erb :index
end

post '/items' do
  name = params[:name]
  DB.execute("INSERT INTO items (name) VALUES (?)", name)
  redirect '/'
end

delete '/items/:id' do
  id = params[:id]
  DB.execute("DELETE FROM items WHERE id = ?", id)
  redirect '/'
end

# Views (using embedded Ruby)
__END__

@@ index
<!DOCTYPE html>
<html>
<head>
  <title>Sinatra SQLite Example</title>
</head>
<body>
  <h1>Items</h1>
  <ul>
    <% @items.each do |item| %>
      <li>
        <%= item[1] %>
        <form action="/items/<%= item[0] %>" method="post" style="display:inline;">
          <input type="hidden" name="_method" value="delete">
          <button type="submit">Delete</button>
        </form>
      </li>
    <% end %>
  </ul>
  <form action="/items" method="post">
    <input type="text" name="name" placeholder="Enter item name">
    <button type="submit">Add Item</button>
  </form>
  <hr>
  <h2>Dropdown Menu</h2>
  <form action="/select_item" method="post">
    <select name="item">
      <% @items.each do |item| %>
        <option value="<%= item[1] %>"><%= item[1] %></option>
      <% end %>
    </select>
    <button type="submit">Select Item</button>
  </form>
</body>
</html>
