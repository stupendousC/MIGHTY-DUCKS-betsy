require "test_helper"

describe MerchantsController do
  describe "auth_callback" do
    ### Copied from lecture notes, rewritten comments to make better sense to me
    it "logs in an existing merchant and redirects to the root route" do
      # Yml seeds are automatically in the database, since we're testing an existing merchant,
      # we're not expecting Merchant.count to change in this block
      start_count_before = Merchant.count
      assert(start_count_before == 2)
      
      # Get a merchant from the fixtures, which we KNOW is in the db
      merchant = merchants(:grace)
      
      # Tell OmniAuth to use this merchant's info when it sees an auth callback from github
      # this will fake a hashie to look as if it came from github
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      
      # Send a login request for that merchant
      get auth_callback_path(:github)
      
      ### The following line is REFACTORING the previous 7 lines.  
      ### We'll be using this for the next tests
      # merchant = perform_login(merchants(:grace))
      
      # following the ctrller logic, we should end up here
      must_redirect_to root_path
      assert(flash[:success] == "Logged in as returning merchant #{merchant.name}")
      
      # check that the merchant ID was set as expected
      assert(session[:merchant_id] == merchant.id)
      
      # Should *not* have created a new merchant
      assert(Merchant.count == start_count_before)
    end
    
    it "creates an account for a new merchant and redirects to the root route" do
      # new merchant, therefore making new data here, b/c yml are already created in db
      # now expecting Merchant.count to change in this block
      start_count_before = Merchant.count
      assert(start_count_before == 2)
      
      # Make a new merchant
      new_merchant = Merchant.new(name:"new person", email:"nobody@nobody.com", uid: "1357", provider: "github")
      
      ### REFACTORING THIS BELOW, see line 54
      # # Tell OmniAuth to use this merchant's info when it sees an auth callback from github
      # # this will fake a hashie to look as if it came from github
      # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      
      # # Send a login request for that merchant
      # get auth_callback_path(:github)
      
      ### As mentioned on line 46, I'm refactoring the prev lines into this next line:
      perform_login(new_merchant)
      
      # following the ctrller logic, we should end up here
      must_redirect_to root_path
      assert(flash[:success] == "Logged in as new merchant #{new_merchant.name}")
      
      # check that the merchant ID was set as expected
      db_new_merchant = Merchant.find_by(name: new_merchant.name)
      assert(session[:merchant_id] == db_new_merchant.id)
      
      # Should *not* have created a new merchant
      assert(Merchant.count == start_count_before + 1)
      # no need to check for correct attrib on Merchant.last b/c that's covered by Model tests
    end
    
    describe "Edge cases" do 
      it "if name == nil" do
        # Arrange
        start_count_before = Merchant.count
        assert(start_count_before == 2)
        
        bogus_merchant = Merchant.new(name:nil, email:"nobody@nobody.com", uid: "1357", provider: "github")
        
        # Act
        perform_login(bogus_merchant)
        
        # ASSERT
        must_redirect_to root_path
        assert(flash[:error] == "Could not create new merchant account!")
        assert(flash[:error_msgs].length == 1)
        assert(flash[:error_msgs].first == "Name can't be blank")
        assert(Merchant.count == start_count_before)
        refute(session[:merchant_id])
      end
      
      it "if email == nil" do
        start_count_before = Merchant.count
        assert(start_count_before == 2)
        
        bogus_merchant = Merchant.new(name:"nobody", email:nil, uid: "1357", provider: "github")
        
        perform_login(bogus_merchant)
        
        must_redirect_to root_path
        assert(flash[:error] == "Could not create new merchant account!")
        assert(flash[:error_msgs].length == 1)
        assert(flash[:error_msgs].first == "Email can't be blank")
        assert(Merchant.count == start_count_before)
        refute(session[:merchant_id])
      end
      
      it "if name is not unique" do
        start_count_before = Merchant.count
        assert(start_count_before == 2)
        bogus_merchant = Merchant.new(name:"countess_ada", email:"second_email.com", uid: "1217", provider: "github")
        
        perform_login(bogus_merchant)
        
        must_redirect_to root_path
        
        assert(flash[:error] == "Could not create new merchant account!")
        assert(flash[:error_msgs].length == 1)
        assert(flash[:error_msgs].first == "Name has already been taken")
        assert(Merchant.count == start_count_before)
        refute(session[:merchant_id])
      end
      
      it "if email is not unique" do
        start_count_before = Merchant.count
        assert(start_count_before == 2)
        bogus_merchant = Merchant.new(name:"Nobody", email:"ada@adadevelopersacademy.org", uid: "1217", provider: "github")
        
        perform_login(bogus_merchant)
        
        must_redirect_to root_path
        assert(flash[:error] == "Could not create new merchant account!")
        assert(flash[:error_msgs].length == 1)
        assert(flash[:error_msgs].first == "Email has already been taken")
        assert(Merchant.count == start_count_before)
        refute(session[:merchant_id])
      end
    end
  end
  
  describe "LOGOUT" do
    it "valid merchant can logout correctly" do
      perform_login
      
      delete logout_path
      
      refute(session[:merchant_id])
      refute(session[:merchant_name])
      assert(flash[:success] == "Successfully logged out!")
      must_redirect_to root_path
    end
    
    it "non-logged-in person cannot logout" do
      get root_path
      refute(session[:merchant_id])
      
      delete logout_path
      
      # should see before_action's require_login kick in with error msg & redirect
      assert(flash[:error] == "You must be logged in to view this section")
      must_redirect_to root_path
    end
    
  end
  
end

