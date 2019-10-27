class MerchantsController < ApplicationController
  
  before_action :require_login, except: [:login]
  
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
  end
  
  def update
    if @merchant.update(merchant_params)
      flash[:success] = "Information was updated"
      redirect_to merchant_path(@merchant.id)
      return
    else
      flash.now[:error] = "Unable to update"
      flash.now[:error_msgs] = @merchant.errors.full_messages
      render action: "edit"
      return
    end
  end
  
  def show
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
  
  def merchant_params
    return params.require(:merchant).permit(:name, :email)
  end
  
  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      return redirect_to root_path
    end
  end
end
