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
      
      # following the ctrller logic, we should end up here
      must_redirect_to root_path
      assert(flash[:success] == "Logged in as returning merchant #{merchant.name}")
      
      # check that the merchant ID was set as expected
      assert(session[:merchant_id] == merchant.id)
      
      # Should *not* have created a new merchant
      assert(Merchant.count == start_count_before)
    end
    
    it "creates an account for a new merchant and redirects to the root route" do
      # new merchant, therefore making new data here, b/c yml are all created in db
          ]

    end
    
    it "redirects to the login route if given invalid merchant data" do
    end
  end
end
