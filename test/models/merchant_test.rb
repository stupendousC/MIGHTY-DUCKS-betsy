require "test_helper"

describe Merchant do
  
  describe "self.build_from_github works?" do
    it "given auth_hash, will build new Merchant instance correctly" do
      #give it an auth_hash somehow...
      auth_hash = request.env["omniauth.auth"]
      #Then call on Build from method to create a hash.
      merchant = Merchant.build_from_github(auth_hash)
      #If a correct build hash is made it will have a name,
      #email, provider, name
      #email should be an instance of a string
      #Name should be an instanc 
    end
    
    it "given bad auth_" do
    end
  end 
  
  
  describe "validations work?" do
    
    it "can validate nominal cases of name" do
      new_merchant = Merchant.new(name:"new person", email:"nobody@nobody.com", uid: "1357", provider: "github")

    end
    
    it "can validate nominal cses of email" do
    end
    
    it "will reject edge cases of name" do
    end
    
    it "will reject edge cases of email" do
    end
    
  end
  
  
end
