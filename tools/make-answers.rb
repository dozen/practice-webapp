require 'json'
require 'faker'

data = []

stop = DateTime.now
start = stop - 365

themes = ''

File.open('data/themes.json', 'r') do |f|
        themes += f.read
end
themes = JSON.parse(themes)

(1..100000).each do
	text = Faker::Lorem.sentence 3
	theme_id = Random.rand(0...4000)
	theme = themes[theme_id]

	data << {
			text: text,
			user_id: Random.rand(1..98459),
			theme_id: theme_id,
			created_at: Faker::Time.between(theme["created_at"], stop)
		}
end

File.write('data/answers.json', JSON.unparse(data))
