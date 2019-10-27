# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Merchant.create(name: "Plucky", uid: "000", provider: "github", email: "plucky@tinytoons.com")
Merchant.create(name: "Caroline", uid: "47910008", provider: "github", email: "caroline@wu.com")
# no need to seed any of us as a merchant, once u log in for real w/ github/omniauth, you'll be in the system
# we will NOT be able to log in as Plucky, since that's not a real Github acct, he's just a test. 
# therefore, no point in attributing any products to him since we can't play with his dashboard anyway...
m0 = Merchant.first.id  # keep Plucky around for now, just in case
m1 = Merchant.last.id

Category.create(name: "Toys")
Category.create(name: "Live Animals")
Category.create(name: "Food")
Category.create(name: "Miscellaneous")
c1 = Category.find_by(name: "Toys").id
c2 = Category.find_by(name: "Live Animals").id
c3 = Category.find_by(name: "Food").id
c4 = Category.find_by(name: "Miscellaneous").id


products = [ 
  { name: "duck socks", stock: 5, price: 2000, category_ids: [c1, c4], merchant_ids: [m1], description: "real spiffy!", img_url: "https://live.staticflickr.com/4081/4906646028_1be7b70d6d_z.jpg"},
  { name: "striped socks", stock: 5, price: 1500, category_ids: [c4], merchant_ids: [m1], description: "stripe it up real good y'all!", img_url: "https://live.staticflickr.com/8325/8380147041_d41c824ba6_z.jpg"},
  { name: "mutant duck", stock: 1, price: 99, category_ids: [c2], merchant_ids: [m1], description: "a true abomination, he'll probably eat you in your sleep, but think about how cool it looks to have an alligator duck!  Be the envy of your friends and buy it now!  Please!!!", img_url: "https://live.staticflickr.com/2345/1805702317_3def904678.jpg"},
  { name: "evil ducks", stock: 8, price: 666, category_ids: [c1], merchant_ids: [m1], description: "they voted for Trump... just look at them, in a circle huddled together, plotting and scheming, talking about who knows what... I bet they're talking about how they plan to take a dump in your shoes later, ooooh they bad!!  Add them to your cart, collect them all!", img_url: "https://live.staticflickr.com/1203/566154297_84ec445540_z.jpg"}
  
  # general format for adding more (don't forget to add comma to the preceding line)
  # { name: "XXX", stock: 1, price: 99, category_ids: [], merchant_ids: [], description: "", img_url: "" }
]

products.each do |product|
  Product.create(name: product[:name], stock: product[:stock], price: product[:price], category_ids: product[:category_ids], merchant: Merchant.last, description: product[:description], img_url: product[:img_url])
end
