# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Merchant.create(name: "Plucky", uid: "000", provider: "github", email: "plucky@tinytoons.com")
Merchant.create(name: "Caroline", uid: "47910008", provider: "github", email: "caroline@wu.com")
# no need to seed any of us as a merchant, once u log in for real w/ github/omniauth, you'll be in the system
# we will NOT be able to log in as Plucky, since that's not a real Github acct, he's just a test


products = [ 
  { name: "duck socks", stock: 5, price: 2000, description: "real spiffy!", img_url: "https://live.staticflickr.com/4081/4906646028_1be7b70d6d_z.jpg"},
  { name: "striped socks", stock: 5, price: 1500, description: "", img_url: ""},
  { name: "striped ducks", stock: 5, price: 750, description: "", img_url: ""},
  { name: "evil ducks", stock: 8, price: 666, description: "", img_url: ""},
  
  # general format for adding more
  { name: "XXX", stock: 1, price: 99, description: "", img_url: "" }
]

products.each do |product|
  # Product.create(name: product[:name], stock: product[:stock], price: product[:price], merchant: )
end
