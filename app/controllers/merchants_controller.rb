class MerchantsController < ApplicationController
  
  before_action :require_login, except: [:login]
  
  def index
    ### IS THIS NECESSARY???
  end
  
  def login
    auth_hash = request.env["omniauth.auth"]
    @merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if @merchant
      # merchant was found in the database
      flash[:success] = "Logged in as returning merchant #{@merchant.name}"
    else
      # merchant doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)
      
      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.name}"
        @merchant = Merchant.last
      else
        flash[:error] = "Could not create new merchant account!"
        flash[:error_msgs] = merchant.errors.full_messages
        return redirect_to root_path
      end
    end
    
    # If we get here, we have a valid merchant instance
    session[:merchant_id] = @merchant.id
    session[:merchant_name] = @merchant.name
    return redirect_to root_path
  end
  
  def edit
    # Do we want to edit their name or email? 
  end
  
  def update
    # Do we want this?
  end
  
  def show
    @products = @merchant.products
    #Get the merchant id by seeing if they are in session
    #find the merchant using their UID or session id
    #If you don't find them output Merchant is not found in a flash
    #then render the same page so they have a chance to input a differnt merchant
    #Don't forget to return
  end
  
  def destroy
    # UNNECESSARY???
  end
  
  def logout
    session[:merchant_id] = nil
    session[:merchant_name] = nil
    flash[:success] = "Successfully logged out!"
    return redirect_to root_path
  end
  
  
  
  private
  def current_merchant
    @merchant ||= Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end
  
  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end
    
  end
end