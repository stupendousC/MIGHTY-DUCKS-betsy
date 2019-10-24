class MerchantsController < ApplicationController
  
  def index
    ### IS THIS NECESSARY???
  end
  
  def login
    auth_hash = request.env["omniauth.auth"]
    
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      # merchant was found in the database
      flash[:success] = "Logged in as returning merchant #{merchant.name}"
    else
      # merchant doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)
      
      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.name}"
      else
        # Couldn't save the merchant for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = "Could not create new merchant account!"
        flash[:error_msgs] = merchant.errors.full_messages
        return redirect_to root_path
      end
    end
    
    # If we get here, we have a valid merchant instance
    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end
  
  def edit
    #What are we editing? shouldn't we just allow the merchant to edit their products
    # Are we allowing them to edit their name or email? That doesn't seem right?

  end
  
  def update
    #What would we be able to update in merchant...a merchant can update it's products, but that would be the 
    #the role of the products controller

  end
  
  def show
    #Get the merchant id by seeing if they are in session
    #find the merchant using their UID or session id
    #If you don't find them output Merchant is not found in a flash
    #then render the same page so they have a chance to input a differnt merchant
    #Don't forget to return
  end
  
  def destroy
    #I don't know if this would work
    loggedin_merchant = session[:merchant_id].id
  
      loggedin_merchant = nil
      flash[:success] = "Successfully logged out!"
  
      redirect_to root_path
    end
  end
  
  #Now I think we probably will not need this action:
  def logout
  end
  
end
