require 'json'
require 'faker'

data = []

stop = DateTime.now
start = stop - 365


(1..4000).each do
	data << {
			user_id: Random.rand(1...98459),
			image_id: Random.rand(1...4000),
			created_at: Faker::Time.between(start, stop)
		}
end

File.write('data/themes.json', JSON.unparse(data))
