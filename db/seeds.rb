# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Merchant.create(name: "Plucky", uid: "000", provider: "github", email: "plucky@tinytoons.com")
# we will NOT be able to log in as Plucky, since that's not a real Github acct, he's just a test. 
# therefore, no point in attributing any products to him since we can't play with his dashboard anyway...
m0 = Merchant.first.id  # keep Plucky around for now, just in case

Merchant.create(name: "Caroline", uid: "47910008", provider: "github", email: "caroline@ada.com")
m1 = Merchant.find_by(name: "Caroline")
Merchant.create(name: "Diana", uid: "37133508", provider: "github", email: "diana@ada.com")
m2 = Merchant.find_by(name: "Diana")
Merchant.create(name: "Kelsey", uid: "38271546", provider: "github", email: "kelsey@ada.com")
m3 = Merchant.find_by(name: "Kelsey")
Merchant.create(name: "Steph", uid: "15236701", provider: "github", email: "steph@ada.com")
m4 = Merchant.find_by(name: "Steph")


Category.create(name: "Toys")
Category.create(name: "Live Animals")
Category.create(name: "Food")
Category.create(name: "Miscellaneous")
c1 = Category.find_by(name: "Toys").id
c2 = Category.find_by(name: "Live Animals").id
c3 = Category.find_by(name: "Food").id
c4 = Category.find_by(name: "Miscellaneous").id


products = [ 
  { name: "duck socks", stock: 5, price: 2000, category_ids: [c1, c4], merchant: m1, description: "real spiffy!", img_url: "https://live.staticflickr.com/4081/4906646028_1be7b70d6d_z.jpg"},
  { name: "striped socks", stock: 5, price: 1500, category_ids: [c4], merchant: m1, description: "stripe it up real good y'all!", img_url: "https://live.staticflickr.com/8325/8380147041_d41c824ba6_z.jpg"},
  { name: "mutant duck", stock: 1, price: 99, category_ids: [c2], merchant: m1, description: "a true abomination, he'll probably eat you in your sleep, but think about how cool it looks to have an alligator duck!  Be the envy of your friends and buy it now!  Please!!!", img_url: "https://live.staticflickr.com/2345/1805702317_3def904678.jpg"},
  { name: "evil ducks", stock: 8, price: 666, category_ids: [c1], merchant: m2, description: "they voted for Trump... just look at them, in a circle huddled together, plotting and scheming, talking about who knows what... I bet they're talking about how they plan to take a dump in your shoes later, ooooh they bad!!  Add them to your cart, collect them all!", img_url: "https://live.staticflickr.com/1203/566154297_84ec445540_z.jpg"},
  { name: "nerdy ducks", stock: 1, price: 3000, category_ids: [c1], merchant: m2, description: "I mean... just look at these cuties!  They're so good with coding and math, these duckies will hack their way straight into your heart <3", img_url: "https://live.staticflickr.com/8498/8368171718_6ee9fdbf67.jpg" },
  { name: "pirate ducks", stock: 2, price: 1999, category_ids: [c1], merchant: m2, description: "y'argh matey! Come along on a swashbuckling adventure with these tough little squeakers!  You don't need no parrot on your shoulder when you got these awesome bird-approximations! ", img_url: "https://live.staticflickr.com/2802/4484631943_8c8c763a81.jpg" },
  { name: "weirdo duck", stock: 1, price: 350, category_ids: [c1], merchant: m3, description: "Um, it's a real happening look ok? Some people like it... If you just buy it, you'll totally learn to love it too!  So yeah, click that BUY button!", img_url: "https://live.staticflickr.com/206/506191695_eee7303a24.jpg" },
  
  { name: "daisy duck", stock: 10, price: 525, category_ids: [c1], merchant: m3, description: "this daisy duck doesn't need no daisy dukes, she'll do what she wants, dagnab it!  But seriously though, you need to buy this...", img_url: "https://live.staticflickr.com/3037/2856164396_5cc2df271e.jpg" },
  { name: "police ducks", stock: 2, price: 2099, category_ids: [c1], merchant: m3, description: "You don't have to worry about bad guys when you have these defenders of justice on your side!  Bad boys, bad boys, whatchu gonna do? Whatchu gonna do when they come for you?  Buy this duck of course!", img_url: "https://live.staticflickr.com/3101/2819378644_2be90721e6.jpg" },
  
  
  { name: "doggy duck", stock: 1, price: 1099, category_ids: [c1], merchant: m4, description: "When a dog and a duck love each other very much, they do a special kind of hug, and thus... this thing is born!  You should buy it.", img_url: "https://live.staticflickr.com/2038/2128859065_ca0ed8f16d.jpg" },
  { name: "tres amigos", stock: 1, price: 5900, category_ids: [c1], merchant: m4, description: "We're selling this as a set, they can't bear to be apart!  These 3 amigos need to stay together at all times :-D", img_url: "https://live.staticflickr.com/3149/2818279661_f8e438d0da.jpg" },
  { name: "giant duck", stock: 1, price: 500000, category_ids: [c4], merchant: m4, description: "Now you too, can terrorize innocent sailors with this monstrosity... check out the size of this thing!  It truly is a rubber ducky of the Gods... BUY IT!", img_url: "https://live.staticflickr.com/2807/8758506394_530e29fd13.jpg" },
]

products.each do |product|
  Product.create(name: product[:name], stock: product[:stock], price: product[:price], category_ids: product[:category_ids], merchant: product[:merchant], description: product[:description], img_url: product[:img_url])
end
