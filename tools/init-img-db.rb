require 'mysql2'

c = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'ogiri')

s = c.prepare('INSERT INTO images (id, type, image) VALUES (?, ?, ?)')

(1..4000).each do |n|
  begin
    img = File.open("img/#{n}.png", 'r').read
    s.execute(n, 'image/png', img)
  rescue
    puts "#{n}.png なし"
    next
  end

end
