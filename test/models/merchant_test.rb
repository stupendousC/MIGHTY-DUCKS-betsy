require "test_helper"

describe Merchant do
  describe "self.build_from_github works?" do
    it "given auth_hash, will build new Merchant instance correctly" do
      #give it an auth_hash somehow...
      auth_hash = {
        provider:"github",
        uid: "1234",
        info: {
          email: "test@email.com",
          name: "test Merchant"
        }
      }
      
      # auth_hash = request.env["omniauth.auth"]
      #Then call on Build from method to create a hash
      # new_merchant = Merchant.build_from_github(auth_hash)
      new_merchant = Merchant.build_from_github(auth_hash)
      expect(new_merchant.uid).must_equal "1234"
      expect(new_merchant.email).must_equal "test@email.com"
      expect(new_merchant.name).must_equal "test Merchant"
    end
    
    it "given bad auth_hash" do
      #Here I am going to test what is being passed in to the Build_from_github
      #Must raise error
      auth_hash = "garbage"
      expect {Merchant.build_from_github(auth_hash)}.must_raise TypeError
    end
    
  end 
  
  describe "validations work?" do
    it "can validate nominal cases of name" do
      new_merchant = Merchant.new(name:"new person", email:"nobody@nobody.com", uid: "1357", provider: "github")
      
      expect(new_merchant.valid?).must_equal true
    end
    
    it "can validate nominal cases of email" do
      new_merchant = Merchant.new(name:"new person", email: "nobody@nobody.com", uid: "1357", provider: "github")
      expect(new_merchant.valid?).must_equal true
      
    end
    
    it "will reject edge cases: blank name" do
      new_merchant = Merchant.new(name:" ", email: "nobody@nobody.com", uid: "1357", provider: "github")
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :name
      expect(new_merchant.errors.messages[:name]).must_equal ["can't be blank"]
    end
    
    it "will reject edge cases: non-unique name" do
      new_merchant = Merchant.new(name:"countess_ada", email: "nobody@nobody.com", uid: "1357", provider: "github")
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :name
      expect(new_merchant.errors.messages[:name]).must_equal ["has already been taken"]
    end
    
    it "will reject edge cases of email: blank email" do
      new_merchant = Merchant.new(name:"test person" , email:" ", uid: "1357", provider: "github")
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
      expect(new_merchant.errors.messages[:email]).must_equal ["can't be blank", "is invalid"]
    end 
    
    it "will reject edge cases of email: non-unique email" do
      new_merchant = Merchant.new(name:"test person" , email:"ada@adadevelopersacademy.org", uid: "1357", provider: "github")
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
      expect(new_merchant.errors.messages[:email]).must_equal ["has already been taken"]
    end 
    
    it "will reject edge cases of email: bogus email" do
      bad_args = [ 123, "123", "@gmail.com", "nobody", "fake@", "fake@fake", "fake.com", "@.", "fake@fake."]
      
      bad_args.each do |bad_arg|
        new_merchant = Merchant.new(name:"test person" , email: bad_arg, uid: "1357", provider: "github")
        
        expect(new_merchant.valid?).must_equal false
        expect(new_merchant.errors.messages).must_include :email
        expect(new_merchant.errors.messages[:email]).must_equal ["is invalid"]
      end
    end 
  end
end
