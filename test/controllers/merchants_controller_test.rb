require "test_helper"

describe MerchantsController do
  describe "auth_callback" do
    it "logs in an existing merchant and redirects to the root route" do
      # Count the merchants, to make sure we're not (for example) creating
      # a new merchant every time we get a login request
      start_count = Merchant.count
      assert(start_count == 2)
      
      # Get a merchant from the fixtures
      merchant = merchants(:grace)
      
      # Tell OmniAuth to use this merchant's info when it sees
      # an auth callback from github
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      
      # Send a login request for that merchant
      # Note that we're using the named path for the callback, as defined
      # in the `as:` clause in `config/routes.rb`
      get auth_callback_path(:github)
      
      must_redirect_to root_path
      
      # Since we can read the session, check that the merchant ID was set as expected
      session[:merchant_id].must_equal merchant.id
      
      # Should *not* have created a new merchant
      Merchant.count.must_equal start_count
    end
    
    it "creates an account for a new merchant and redirects to the root route" do
    end
    
    it "redirects to the login route if given invalid merchant data" do
    end
  end
end
