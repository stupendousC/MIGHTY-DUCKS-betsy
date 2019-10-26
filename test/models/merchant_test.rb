require "test_helper"

describe Merchant do
  describe "self.build_from_github works?" do
    it "given auth_hash, will build new Merchant instance correctly" do
      auth_hash = {
        provider:"github",
        uid: "1234",
        info: {
          email: "test@email.com",
          name: "test Merchant"
        }
      }
      new_merchant = Merchant.build_from_github(auth_hash)
      expect(new_merchant.uid).must_equal "1234"
      expect(new_merchant.email).must_equal "test@email.com"
      expect(new_merchant.name).must_equal "test Merchant"
    end
    
    it "given an auth_hash that is not a hash will raise a Error" do
      auth_hash = 12321421123
      expect {new_merchant = Merchant.build_from_github(auth_hash)}.must_raise TypeError
    end
    
    it "given an empty auth_hash will raise an Error" do
      auth_hash = {}
      expect{ new_merchant = Merchant.build_from_github(auth_hash)}.must_raise NoMethodError
    end
    
    it "given a hash with false infomation hash will raise a Error" do
      auth_hash = {'hello' => 3432, "testing"=> 23431}
      expect{ new_merchant = Merchant.build_from_github(auth_hash)}.must_raise NoMethodError
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
    
    it "will reject edge cases of name" do
      new_merchant = Merchant.new(name:" ", email: "nobody@nobody.com", uid: "1357", provider: "github")
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :name
      expect(new_merchant.errors.messages[:name]).must_equal ["can't be blank"]
    end
    
    it "will reject edge cases of email" do
      new_merchant = Merchant.new(name:"test person" , email:" ", uid: "1357", provider: "github")
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
      expect(new_merchant.errors.messages[:email]).must_equal ["can't be blank"]
    end 
  end
end
