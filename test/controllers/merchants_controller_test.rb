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
      
      # Should *not* have created a new merchant
      assert(Merchant.count == start_count_before + 1)
      # no need to check for correct attrib on Merchant.last b/c that's covered by Model tests
      
    end
    
    # it "redirects to the login route if given invalid merchant data" do
    #   # new but BOGUS merchant
    #   # now expecting Merchant.count to NOT change b/c it shouldn't get saved to db
    #   start_count_before = Merchant.count
    #   assert(start_count_before == 2)
    
    #   # Make a new merchant
    #   merchant = Merchant.new(name:nil, email:"nobody@nobody.com", uid: "1357", provider: "github")
    
    #   # Tell OmniAuth to use this merchant's info when it sees an auth callback from github
    #   # this will fake a hashie to look as if it came from github
    #   OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
    
    #   # Send a login request for that merchant
    #   get auth_callback_path(:github)
    
    #   # following the ctrller logic, we should end up here
    #   must_redirect_to root_path
    #   assert(flash[:success] == "Logged in as new merchant #{merchant.name}")
    
    #   # Should *not* have created a new merchant
    #   assert(Merchant.count == start_count_before + 1)
    #   # no need to check for correct attrib on Merchant.last b/c that's covered by Model tests
    
    
    # end
  end
end
