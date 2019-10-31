require "test_helper"

describe MerchantsController do
  
  let (:ada) { merchants(:ada) }
  let (:grace) { merchants(:grace) }
  
  describe "LOGIN" do
    ### Copied from lecture notes, rewritten comments to make better sense to me
    it "logs in an existing merchant and redirects to the root route" do
      # Yml seeds are automatically in the database, since we're testing an existing merchant,
      # we're not expecting Merchant.count to change in this block
      start_count_before = Merchant.count
      
      # Get a merchant from the fixtures, which we KNOW is in the db
      merchant = merchants(:m1)
      
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
      expect(flash[:success]).must_equal "Logged in as returning merchant #{merchant.name}"
      
      # check that the merchant ID was set as expected
      expect(session[:merchant_id]).must_equal merchant.id
      
      # Should *not* have created a new merchant
      assert(Merchant.count == start_count_before)
    end
    
    it "creates an account for a new merchant and redirects to the root route" do
      # new merchant, therefore making new data here, b/c yml are already created in db
      # now expecting Merchant.count to change in this block
      start_count_before = Merchant.count
      
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
        
        bogus_merchant = Merchant.new(name:nil, email:"nobody@nobody.com", uid: "1357", provider: "github")
        
        # Act
        perform_login(bogus_merchant)
        
        # ASSERT
        must_redirect_to root_path
        assert(flash[:error] == "Could not create new merchant account!")
        assert(flash[:error_msgs] == ["Name can't be blank"])
        assert(Merchant.count == start_count_before)
        refute(session[:merchant_id])
      end
      
      it "if email == nil" do
        start_count_before = Merchant.count
        
        bogus_merchant = Merchant.new(name:"nobody", email:nil, uid: "1357", provider: "github")
        
        perform_login(bogus_merchant)
        
        must_redirect_to root_path
        assert(flash[:error] == "Could not create new merchant account!")
        assert(flash[:error_msgs] == ["Email can't be blank", "Email is invalid"])
        assert(Merchant.count == start_count_before)
        refute(session[:merchant_id])
      end
      
      it "if name is not unique" do
        start_count_before = Merchant.count
        bogus_merchant = Merchant.new(name:"countess_ada", email:"second@email.com", uid: "1217", provider: "github")
        
        perform_login(bogus_merchant)
        
        must_redirect_to root_path
        
        assert(flash[:error] == "Could not create new merchant account!")
        assert(flash[:error_msgs] == ["Name has already been taken"])
        assert(Merchant.count == start_count_before)
        refute(session[:merchant_id])
      end
      
      it "if email is not unique" do
        start_count_before = Merchant.count
        bogus_merchant = Merchant.new(name:"Nobody", email:"ada@adadevelopersacademy.org", uid: "1217", provider: "github")
        
        perform_login(bogus_merchant)
        
        must_redirect_to root_path
        assert(flash[:error] == "Could not create new merchant account!")
        assert(flash[:error_msgs] == ["Email has already been taken"])
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
  
  describe "SHOW" do
    it "if logged in: can go to merchant's own page" do
      perform_login(ada)
      
      expect(session[:merchant_name]).must_equal "countess_ada"
      get merchant_path(ada)
      must_respond_with :success
    end
    
    it "if not logged in: send to homepage w/ error msg" do
      get merchant_path(id: 0)
      
      must_redirect_to root_path
      assert(flash[:error] == "You must be logged in to view this section")
    end
  end
  
  describe "EDIT" do
    it "if logged in: can go to merchant's edit page" do
      perform_login(ada)
      
      expect(session[:merchant_name]).must_equal "countess_ada"
      get edit_merchant_path(ada)
      must_respond_with :success
    end
    
    it "if not logged in: send to homepage w/ error msg" do
      get merchant_path(id: 0)
      
      must_redirect_to root_path
      assert(flash[:error] == "You must be logged in to view this section")
    end
  end
  
  describe "UPDATE" do
    it "if logged in: can successfully update" do
      perform_login(ada)
      good_params = { merchant: { name: "ada v2", email: "ada@v2.com" } }
      
      patch merchant_path(ada), params: good_params 
      expect(flash[:success]).must_equal "Information was updated"
      expect(session[:merchant_name]).must_equal "ada v2"
      must_redirect_to merchant_path(ada)
    end
    
    it "if logged in: bogus new info will render same page with error msgs" do
      perform_login(ada)
      
      set_of_bad_params = [
      { merchant: { name: "", email: "" } },
      { merchant: { name: "", email: "ada@v2.com" } },
      { merchant: { name: "ada v2", email: "" } },
      { merchant: { name: grace.name, email: grace.email } },
      { merchant: { name: "ada v2", email: grace.email } },
      { merchant: { name: grace.name, email: "ada@v2.com" } }
    ]
    
    set_of_bad_params.each do |bad_params|
      patch merchant_path(ada), params: bad_params 
      expect(flash[:error]).must_equal "Unable to update"
      # each of the bad cases have diff msgs, which are tested in Model. 
      # therefore only need to assert their existence here
      assert(flash[:error_msgs])
      must_respond_with :success
    end
    
  end
  
  it "if not logged in: send to homepage w/ error msg" do
    patch merchant_path(ada)
    
    must_redirect_to root_path
    assert(flash[:error] == "You must be logged in to view this section")
  end
end
end