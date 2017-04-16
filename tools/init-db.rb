require 'mysql2'
require 'json'
require 'digest/sha2'

c = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'ogiri')

<<EOC
themes = JSON.parse(File.open('data/themes.json', 'r').read)
stmt = c.prepare('INSERT INTO themes (user_id, image_id, created_at) VALUES (?, ?, ?)')

themes.each do |t|
	stmt.execute(t['user_id'], t['image_id'], t['created_at'])
end

themes = nil


users = JSON.parse(File.open('data/users.json', 'r').read)
stmt = c.prepare('INSERT INTO users (name, hash) VALUES (?, ?)')

hash = Digest::SHA256.hexdigest "password_salt"

users.each do |u|
	stmt.execute(u, hash)
end

users = nil

EOC

votes = JSON.parse(File.open('data/votes.json', 'r').read)
stmt = c.prepare('INSERT INTO votes (comment, user_id, answer_id, point, created_at) VALUES (?, ?, ?, ?, ?)')

votes.each do |v|
	stmt.execute(v['comment'], v['user_id'], v['answer_id'], v['point'], v['created_at'])
end

votes = nil

<<COM
answers = JSON.parse(File.open('data/answers.json', 'r').read)
stmt = c.prepare('INSERT INTO answers (text, user_id, theme_id, created_at) VALUES (?, ?, ?, ?)')

answers.each do |a|
	stmt.execute(a['text'], a['user_id'], a['theme_id'], a['created_at'])
end

COM
