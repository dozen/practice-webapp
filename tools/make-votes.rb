require 'json'
require 'faker'

data = []

stop = DateTime.now
start = stop - 365

answers = ''

File.open('data/answers.json', 'r') do |f|
        answers += f.read
end
answers = JSON.parse(answers)

answer_limit = answers.count

(1..2000000).each do
	comment = Faker::Lorem.sentence 3 if Random.rand(1..10)%10 == 0
	answer_id = Random.rand(0...answer_limit)
	answer = answers[answer_id]

	data << {
			comment: comment,
			user_id: Random.rand(1..98459),
			answer_id: answer_id,
			point: Random.rand(1..3),
			created_at: Faker::Time.between(answer["created_at"], stop)
		}
end

File.write('data/votes.json', JSON.unparse(data))
