require 'json'
require 'rmagick'
require 'faker'

include Magick # 面倒くさいのでinclude

IMG_SRC = 'data/octcat.png'

fail('始まりと終わりを引数で指定してください') if ARGV.length < 2

(ARGV[0]..ARGV[1]).each do |n|
	img = ImageList.new IMG_SRC
	text = Draw.new # 描画オブジェクトを初期化
	text.font = '/System/Library/Fonts/Avenir Next.ttc'
	text.pointsize = 52
	text.gravity = CenterGravity

	text.annotate(img, 0,0,0,0, Faker::Address.city + "\n" + Faker::Address.street_name + "\n" + Faker::Address.zip) {
	   self.fill = 'white';
	   self.stroke_width = 3
	   self.stroke = 'black';
	}

	img.write("img/#{n}.png")
end

