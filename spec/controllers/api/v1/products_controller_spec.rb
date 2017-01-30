require 'spec_helper'

describe Api::V1::ProductsController do

  before(:each) { request.headers['Content-Type'] = "application/json" }

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id, format: :json
    end

    it "returns the information about a product" do
      product_response = JSON.parse(response.body, symbolize_names: true)
      product_response = product_response[:product]
      expect(product_response[:id]).to eql @product.id
      expect(product_response[:name]).to eql @product.name
    end

    it { should respond_with 200 }
  end



  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @product_attributes = FactoryGirl.attributes_for :product
        post :create, { product: @product_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        product_response = JSON.parse(response.body, symbolize_names: true)
        product_response = product_response[:product]
        expect(product_response[:name]).to eql @product_attributes[:name]
        expect(product_response[:description]).to eql @product_attributes[:description]
        expect(product_response[:price]).to eql @product_attributes[:price]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_product_attributes = { name: "test product",
                                     description: "test product description" }
        post :create, { product: @invalid_product_attributes }, format: :json
      end

      it "renders an error message in  response" do
        err_response = JSON.parse(response.body, symbolize_names: true)
        expect(err_response).to have_key(:error)
        expect(err_response[:success]).to eql false
      end

      it "renders the json errors on why the product could not be created" do
        err_response = JSON.parse(response.body, symbolize_names: true)
        expect(err_response[:error][:message]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end

  end

  describe "PUT/PATCH #update" do

    context "when is successfully updated" do
      before(:each) do
        @product = FactoryGirl.create :product
        @product_update_attributes = {id: @product.id, description:"New description for product"}
        patch :update, { id: @product.id, product: @product_update_attributes }, format: :json
      end

      it "renders the json representation for the updated user" do
        product_response = JSON.parse(response.body, symbolize_names: true)
        expect(product_response[:product][:id]).to eql @product_update_attributes[:id]
        expect(product_response[:product][:description]).to eql @product_update_attributes[:description]
      end

      it { should respond_with 201 }
    end

    context "when product is not updated" do
      before(:each) do
        @product = FactoryGirl.create :product
        @product_update_attributes = {id: @product.id, description:nil}
        patch :update, { id: @product.id, product: @product_update_attributes }, format: :json
      end

      it "renders an error message in  response" do
        err_response = JSON.parse(response.body, symbolize_names: true)
        expect(err_response).to have_key(:error)
        expect(err_response[:success]).to eql false
      end

      it "renders the json errors on why the product can't not be updated" do
        err_response = JSON.parse(response.body, symbolize_names: true)
        expect(err_response[:error][:message]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @product = FactoryGirl.create :product
      delete :destroy, { id: @product.id }, format: :json
    end

    it { should respond_with 204 }

  end


end
