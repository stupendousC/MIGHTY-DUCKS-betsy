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


products = 
[ 
  { name: "duck socks", stock: 5, price: 2000, category_ids: [c1, c4], merchant: m1, description: "real spiffy!", img_url: "https://live.staticflickr.com/4081/4906646028_1be7b70d6d_z.jpg"},
  { name: "striped socks", stock: 15, price: 1500, category_ids: [c4], merchant: m1, description: "stripe it up real good y'all!", img_url: "https://live.staticflickr.com/8325/8380147041_d41c824ba6_z.jpg"},
  { name: "mutant duck", stock: 6, price: 99, category_ids: [c2], merchant: m1, description: "a true abomination, he'll probably eat you in your sleep, but think about how cool it looks to have an alligator duck!  Be the envy of your friends and buy it now!  Please!!!", img_url: "https://live.staticflickr.com/2345/1805702317_3def904678.jpg"},
  { name: "newlywed ducks", stock: 3, price: 99999, category_ids: [c1], merchant: m1, description: "Did you forget to buy an anniversary present? Well, how about this set of rubber duckies? Nothing says 'I'm sorry, I totally forgot our anniversary, so I went online and bought this for you so please don't leave me!' like this ultra adorable set of lovey duckies!", img_url: "https://live.staticflickr.com/7231/6913676136_12e589fb06.jpg" },
  { name: "thuggy duckies", stock: 18, price: 599, category_ids: [c1], merchant: m1, description: "Just your average gaggle of thuggy duckies, hanging out and being loud. It's the middle of the day, why aren't they in school?! Kids these days...", img_url: "https://live.staticflickr.com/1200/1409914720_5a48c62868.jpg" },
  { name: "patriot duckies", stock: 30, price: 5000, category_ids: [c1], merchant: m1, description: "There's much darkness out there my friend, but you can bring the sudsy power of democracy with you straight to the tub! Make ablution great again!", img_url: "https://live.staticflickr.com/7408/12673737013_6df8427e5a.jpg" },
  { name: "ducklings", stock: 5, price: 14999, category_ids: [c2], merchant: m1, description: "No ordinary ducklings, they are authentic full-powered Pokemon Psyducks! No fooling! All sales final.", img_url: "https://live.staticflickr.com/2588/3997568068_d46f61413a.jpg" },
  { name: "thousand year old eggs", stock: 100, price: 500, category_ids: [c3], merchant: m1, description: "Utterly delicious, these pungent fermented duck eggs are a true sensory delight! Fantastic with congee or just regular rice!", img_url: "https://live.staticflickr.com/5257/5477438214_7ffcbb256a.jpg" },
  
  { name: "evil ducks", stock: 8, price: 666, category_ids: [c1], merchant: m2, description: "they voted for Trump... just look at them, in a circle huddled together, plotting and scheming, talking about who knows what... I bet they're talking about how they plan to take a dump in your shoes later, ooooh they bad!!  Add them to your cart, collect them all!", img_url: "https://live.staticflickr.com/1203/566154297_84ec445540_z.jpg"},
  { name: "nerdy ducks", stock: 15, price: 3000, category_ids: [c1], merchant: m2, description: "I mean... just look at these cuties!  They're so good with coding and math, these duckies will hack their way straight into your heart <3", img_url: "https://live.staticflickr.com/8498/8368171718_6ee9fdbf67.jpg" },
  { name: "pirate ducks", stock: 20, price: 1999, category_ids: [c1], merchant: m2, description: "y'argh matey! Come along on a swashbuckling adventure with these tough little squeakers!  You don't need no parrot on your shoulder when you got these awesome bird-approximations! ", img_url: "https://live.staticflickr.com/2802/4484631943_8c8c763a81.jpg" },
  { name: "Easter ducks", stock: 20, price: 1500, category_ids: [c1], merchant: m2, description: "Easter duckies, because when you think Easter, what do you think of? Eggs? Wrong! Fun? Doubly wrong! The true meaning of Easter is rubber duckies, I'm pretty sure Jesus said that.", img_url: "https://live.staticflickr.com/8245/8521319302_70279cce27.jpg" },
  { name: "haunted duckies", stock: 2, price: 25, category_ids: [c1], merchant: m2, description: "They look so innocent and sweet, don't they? Well, these ducks are positively haunted! Buy them and you'll see what I mean, oooooooooh...", img_url: "https://live.staticflickr.com/113/289915260_4642aba608.jpg" },
  { name: "halloween duckies", stock: 3, price: 1099, category_ids: [c1], merchant: m2, description: "They did the mash, they did the monster mash... The monster mash, it was a graveyard smash", img_url: "https://live.staticflickr.com/2691/4055796257_c2b4f7ac6a.jpg" },
  { name: "loud ducks", stock: 2, price: 500, category_ids: [c2], merchant: m2, description: "Super loud and obnoxious ducks in my neighborhood, I just want to ship them somewhere far away.  Yours for just $5!", img_url: "https://live.staticflickr.com/5530/9917952154_29219242a4.jpg" },
  { name: "foie gras", stock: 32, price: 3500, category_ids: [c3], merchant: m2, description: "Lobe of foie gras, amazingly delicious, best prepared seared on a pan.  Please don't google how foie gras is made...", img_url: "https://live.staticflickr.com/1527/25641301092_7a8040fb19.jpg" },
  
  { name: "weirdo duck", stock: 12, price: 350, category_ids: [c1], merchant: m3, description: "Um, it's a real happening look ok? Some people like it... If you just buy it, you'll totally learn to love it too!  So yeah, click that BUY button!", img_url: "https://live.staticflickr.com/206/506191695_eee7303a24.jpg" },
  { name: "daisy duck", stock: 10, price: 525, category_ids: [c1], merchant: m3, description: "this daisy duck doesn't need no daisy dukes, she'll do what she wants, dagnab it!  But seriously though, you need to buy this...", img_url: "https://live.staticflickr.com/3037/2856164396_5cc2df271e.jpg" },
  { name: "police ducks", stock: 22, price: 2099, category_ids: [c1], merchant: m3, description: "You don't have to worry about bad guys when you have these defenders of justice on your side!  Bad boys, bad boys, whatchu gonna do? Whatchu gonna do when they come for you?  Buy this duck of course!", img_url: "https://live.staticflickr.com/3101/2819378644_2be90721e6.jpg" },
  { name: "glam duck", stock: 35, price: 50000, category_ids: [c1], merchant: m3, description: "Bonjour mon amour! C'est chic, n'est pas? Je parle francais tres mal! Il faut d'acheter ceci maintenant!!!", img_url: "https://live.staticflickr.com/6002/6001171710_1f705923b2.jpg" },
  { name: "ducky cupcakes", stock: 20, price: 799, category_ids: [c4], merchant: m3, description: "Freshly baked! Get these yummy cupcakes now! Gluten-free, sugar-free, egg-free, flour-free, butter-free, artificial-coloring-free, and calories-free!  What a miracle, so what are you waiting for? Buy this picture of these delicious homemade cupcakes now!", img_url: "https://live.staticflickr.com/3068/2954186382_3345be4af3.jpg" },
  { name: "muscovy ducklings", stock: 32, price: 4000, category_ids: [c2], merchant: m3, description: "Just hatched.  They're super cute.  Please don't eat them.", img_url: "https://live.staticflickr.com/2910/14129129901_6fa70948f9.jpg" },
  { name: "Gary", stock: 1, price: 1000, category_ids: [c2], merchant: m3, description: "Gary and I go way back, since the day he lost his mommy duck and I found him malnourished in the woods, so I brought him back and nursed him back to health.  Then he farted on me... yours for $10", img_url: "https://live.staticflickr.com/5346/8808666284_699c2998be.jpg" },
  { name: "duck drawing", stock: 10, price: 300000, category_ids: [c4], merchant: m3, description: "I'm not sure what this is, but doesn't this look like something you'd like to see hanging on your wall? I know I do!", img_url: "https://live.staticflickr.com/4016/4583062717_f018b7d0c8.jpg" },
  
  { name: "doggy duck", stock: 10, price: 1099, category_ids: [c1], merchant: m4, description: "When a dog and a duck love each other very much, they do a special kind of hug, and thus... this thing is born!  You should buy it.", img_url: "https://live.staticflickr.com/2038/2128859065_ca0ed8f16d.jpg" },
  { name: "tres amigos", stock: 3, price: 5900, category_ids: [c1], merchant: m4, description: "We're selling this as a set, they can't bear to be apart!  These 3 amigos need to stay together at all times :-D", img_url: "https://live.staticflickr.com/3149/2818279661_f8e438d0da.jpg" },
  { name: "giant duck", stock: 1, price: 500000, category_ids: [c4], merchant: m4, description: "Now you too, can terrorize innocent sailors with this monstrosity... check out the size of this thing!  It truly is a rubber ducky of the Gods... BUY IT!", img_url: "https://live.staticflickr.com/2807/8758506394_530e29fd13.jpg" },
  { name: "funky ducks", stock: 21, price: 1200, category_ids: [c1], merchant: m4, description: "Wow, look at them, so fresh and hip.  I heard these are the coolest ducks on the street, they got so much swag!", img_url: "https://live.staticflickr.com/3323/3598094980_bbd1060e77.jpg" },
  { name: "english duck", stock: 10, price: 2500, category_ids: [c1], merchant: m4, description: "Top of the mornin' to ya, guvnor! This English ducky is on active duty so they can't move, which is good news for you, because YOU can! So make your move and snatch it up now for the low, low price of whatever I listed it for!", img_url: "https://live.staticflickr.com/2254/2027052965_abf3f3ad9e.jpg" },
  { name: "solar eclipse duckies", stock: 20, price: 1450, category_ids: [c1], merchant: m4, description: "Check out these savvy duckies! They're ready party with you at the next solar eclipse! Wow your friends with your knowledge of sun safety, and be sure to wear matching shades so you'll look hella cool together!!", img_url: "https://live.staticflickr.com/3213/2419660904_4e27da4239.jpg" },
  { name: "mandarin duck", stock: 1, price: 7000, category_ids: [c2], merchant: m4, description: "Took me forever to catch this little bugger, that's why it's $70.00.  No haggling, serious buyers only!", img_url: "https://live.staticflickr.com/3712/9574548859_92a57e8409.jpg" },
  { name: "duck pistachio terrine", stock: 10, price: 2000, category_ids: [c3], merchant: m4, description: "How am I supposed to know how these taste? I just sell them, ok? Anyway you should totally buy some lol.", img_url: "https://live.staticflickr.com/7072/7188815258_a25018072c.jpg" },
  
  # { name: "", stock: , price: , category_ids: [], merchant: m0, description: "", img_url: "" },
]

products.each do |product|
  Product.create(name: product[:name], stock: product[:stock], price: product[:price], category_ids: product[:category_ids], merchant: product[:merchant], status: "Available", description: product[:description], img_url: product[:img_url])
end

Customer.create(name: "wonder woman", email: "w@w.com", address: "i forgot", city: "somewhere", state: "WA", zip: 11111, cc_name: "gal gadot", cc1: 1234, cc2: 5678, cc3: 8765, cc4: 4321, cc_exp_month: "mar", cc_exp_year: "2022", cc_exp: "mar 2022", cvv: 111, cc_company: "discovery")
Customer.create(name: "aquaman", email: "a@m.com", address: "ocean", city: "atlantis", state: "HI", zip: 54321, cc_name: "jason momoa", cc1: 1111, cc2: 2222, cc3: 3333, cc4: 4444, cc_exp_month: "feb", cc_exp_year: "2021", cc_exp: "feb 2021", cvv: 222, cc_company: "visa")
Customer.create(name: "spiderman", email: "s@p.com", address: "spider web", city: "nyc", state: "NY", zip: 12345, cc_name: "peter parker", cc1: 1234, cc2: 5678, cc3: 8765, cc4: 4321, cc_exp_month: "jan", cc_exp_year: "2020", cc_exp: "jan 2020", cvv: 333, cc_company: "amex")
c1 = Customer.find_by(name: "wonder woman")
c2 = Customer.find_by(name: "aquaman")
c3 = Customer.find_by(name: "spiderman")

o1 = Order.new(status: "paid")
o2 = Order.new(status: "shipped")
o3 = Order.new(status: "pending")
o1.save!
o2.save!
o3.save!
oi1 = OrderItem.create!(qty: 1, product: Product.first, order: o1)
oi2 = OrderItem.create!(qty: 2, product: Product.find(2), order: o2)
oi3 = OrderItem.create!(qty: 3, product: Product.find(3), order: o3)
oi4 = OrderItem.create!(qty: 4, product: Product.last, order: o1)
oi5 = OrderItem.create!(qty: 5, product: Product.last, order: o2)
oi6 = OrderItem.create!(qty: 6, product: Product.last, order: o3)
o1.update!(customer_id: c1.id)
o2.update!(customer_id: c2.id)


Review.create(product: Product.find_by(name: "doggy duck"), rating: 1, comment: "It scares me at night")
Review.create(product: Product.find_by(name: "weirdo duck"), rating: 5, comment: "TOTALLY legit review! wow, so professionally made, it's easily worth 10 times what they're selling for!")
Review.create(product: Product.find_by(name: "weirdo duck"), rating: 1, comment: "Ok, idk what the person above is talking about, this duck is hella fugs...")
Review.create(product: Product.find_by(name: "weirdo duck"), rating: 5, comment: "Obviously this other person is totally jelly because they are a competing merchant selling subpar ducks!  Buy my ducks!  I mean, buy Kelsey's ducks!")
