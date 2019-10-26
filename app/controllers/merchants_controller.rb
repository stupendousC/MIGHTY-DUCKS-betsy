require 'pry'

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
    session[:merchant_id] = @merchant.id
    if @merchant.nil?
      redirect_to root_path
      return
    end
    @merchant = Merchant.find_by(id: session[:merchant_id])
  end
  
  def update
    if @merchant.update(merchant_params)
      redirect_to merchant_path(@merchant.id)
      flash[:success] = "Information was updated"
    else
      flash[:error] = "Please enter valid information"
      render :edit 
    end
  end
  
  def show
    #what the hell is the point of the show action ?
    #@merchant = current_merchant
    #@products = @merchant.products
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
  
  def merchant_params
    return params.require(:merchant).permit(:name, :email, :merchant_id)
  end
  
  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end
end
