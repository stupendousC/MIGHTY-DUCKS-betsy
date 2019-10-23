require "test_helper"

describe ProductsController do
  it "can show product#index page" do
    get products_path
    must_respond_with :success
  end
end
