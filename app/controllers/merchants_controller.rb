class MerchantsController < ApplicationController
  
  def index
    ### IS THIS NECESSARY???
  end
  
  def new
  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    raise
  end
  
  def login
    # if github authenticates Merchant
    # if new merchant
    # call .new and .create
    # set session
    # if existing/returning merchant
    # set session
    
    # else bogus merchant
    # error page
  end
  
  def edit
  end
  
  def update
  end
  
  def show
  end
  
  def destroy
  end
  
  def logout
  end
  
end
