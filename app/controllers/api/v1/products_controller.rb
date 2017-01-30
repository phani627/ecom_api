class Api::V1::ProductsController < ApplicationController
  include API::ApiHelpers

  before_action :check_content_type
  before_action :product_params, only: [:create, :update]

  def index
    @paginate_params = {
        page: (params[:page] || 1),
        per_page: (params[:per_page] || 20)
    }
    @products = Product.paginate(@paginate_params)
    @total_pages = (@products.total_entries/ @paginate_params[:per_page].to_i)+1
    response = @paginate_params.merge({total_pages: @total_pages, products: @products})
    render json: response, status: 200
  end

  def show
    render_api_error(400, "ID must be passed in params") unless params[:id].present?
    begin
      @product = Product.find(params[:id].to_i)
    rescue ActiveRecord::RecordNotFound => e
      return render_api_error(404,e.message)
    end
    render json: {product: @product}, status: 200
  end

  def create
    begin
      @product = Product.new(@create_params)
      unless @product.save
        return render_api_error(422,@product.errors.to_a.join(","))
      end
    end
    render json: {product: @product}, status: 201
  end

  def update
    begin
      @product = Product.find(params[:id].to_i)
      unless @product.update(@update_params)
        return render_api_error(422,@product.errors.to_a.join(","))
      end
    rescue ActiveRecord::RecordNotFound => e
      return render_api_error(404,e.message)
    end
    render json: {product: @product}, status: 201
  end

  def destroy
    begin
      @product = Product.destroy(params[:id].to_i)
    rescue ActiveRecord::RecordNotFound => e
      return render_api_error(404,e.message)
    end
    render json: {product: @product}, status: 204
  end


  private
  def product_params
    @create_params = params.require(:product).permit(:name,:description,:price)
    @update_params = params.require(:product).permit(:id,:name,:description,:price)
  end

end
