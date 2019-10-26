# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



products = [ 
  { name: "duck socks", stock: 5, price: 2000, description: "real spiffy!", img_url = "https://live.staticflickr.com/4081/4906646028_1be7b70d6d_z.jpg"},
  { name: "striped socks", stock: 5, price: 1500},
  { name: "striped ducks", stock: 5, price: 750},
  { name: "evil ducks", stock: 8, price: 666}
]

products.each do |product|
  Product.create(name: product[:name], stock: product[:stock], price: product[:price])
end
