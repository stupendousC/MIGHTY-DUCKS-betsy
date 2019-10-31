require "test_helper"

describe Customer do
  let(:c1) { customers(:c1) }
  let(:o1) { orders(:o1) }
  let(:o2) { orders(:o2) }
  
  describe "Relationships" do
    it "can have more than 1 order" do
      assert(c1.orders.count > 0)
      before = c1.orders.count
      
      c1.orders << o1
      assert(c1.orders.count == before + 1)
    end
  end
  
  describe "Validation" do
    it "can make Customer instance with good inputs" do
      assert(c1.valid?)
    end
    
    describe "edge cases" do
      
      it "won't make Customer instance with nil inputs" do
        nil_everything = Customer.new()
        
        refute(nil_everything.save)
        
        expected_keys = [:name, :email, :address, :city, :state, :zip, :cc_company, :cc_name, :cc1, :cc2, :cc3, :cc4, :cc_exp_month, :cc_exp_year, :cvv]
        expect(nil_everything.errors.keys.count).must_equal expected_keys.count
        nil_everything.errors.keys.each do |key|
          assert(expected_keys.include? key)
        end
        
      end
      
      it "won't make Customer instance with various bad emails" do
        bad_emails = [123, "123", "@gmail.com", "nobody", "fake@", "fake@fake", "fake.com", "@.", "fake@fake."]
        
        bad_emails.each do |bad_email|
          bad_customer = Customer.new(name:"ok", email: bad_email, address: "ok", city: "ok", state: "ok", zip: 123, cc_company: "ok", cc_name: "ok", cc1: 1, cc2: 1, cc3: 1, cc4: 1, cc_exp_month: "ok", cc_exp_year: "ok", cvv: 123)
          refute(bad_customer.save)
          assert(bad_customer.errors.keys == [:email])
        end
      end
    end
  end
  
end