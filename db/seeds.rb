# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

merchant = Merchant.create(name: "Kelsey", email: "kelsey@kelsey.kelsey")
merchant2 = Merchant.create(name: "Diana", email: "diana@diana.diana")
merchant3 = Merchant.create(name: "Steph", email: "steph@steph.steph")
merchant4 = Merchant.create(name: "Caroline", email: "caroline@caroline.caroline")



products = [ 
  { name: "duck socks", qty: 5, price: 2000},
  { name: "striped socks", qty: 5, price: 1500},
  { name: "striped ducks", qty: 5, price: 750},
  { name: "evil ducks", qty: 8, price: 666}
]

products.each do |product|
  Product.create(name: product[:name], stock: product[:qty], price: product[:price], merchant_id: merchant.id)
end
