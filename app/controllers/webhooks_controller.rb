class WebhooksController < ApplicationController
  before_filter :verify_webhook, :except => 'verify_webhook'

  def product_new
    head :ok
    shopify_product_id = params[:id].to_s
    product_type = params[:product_type]
    title = params[:title]
    tags = params[:tags]
    variants = params[:variants]
    NewProductWorker.perform_async(shopify_product_id, title, shop.id, product_type, tags, variants)
  end

  def product_update
    head :ok
    shopify_product_id = params[:id].to_s
    variants = params[:variants]
    title = params[:title]
    ext_shopify_variant_id_array =  variants.map{|variant| variant[:id].to_s}
    unless shop.recurring_charges.last.nil?
      UpdateProductWorker.perform_async(shopify_product_id, title, shop.id, ext_shopify_variant_id_array)
    end
  end

  def product_delete
    head :ok
    shopify_product_id = params[:id].to_s
    ProductDeleteWorker.perform_async(shopify_product_id, shop.id)
  end

  def collection_delete
    head :ok
    shopify_collection_id = params[:id].to_s
    CollectionDeleteWorker.perform_async(shopify_collection_id, shop.id)
  end

  def collection_create
    head :ok
    CollectionCreateWorker.perform_async(shop.id)
  end

  def collection_update
    head :ok
    shopify_collection_id = params[:id]
    CollectionUpdateWorker.perform_async(shop.id, shopify_collection_id, params[:title])
  end

  def app_uninstalled
    head :ok
    StopPriceTestsWorker.perform_async(shop.id)
    DestroyRecurringChargesWorker.perform_async(shop.id)
  end

  def shop_update
    head :ok
    plan_name = params[:plan_name]
    ShopUpdateWorker.perform_async(shop.id, plan_name)
  end

  private

  def verify_webhook
    data = request.body.read.to_s
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    digest  = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, Rails.configuration.shopify_secret, data)).strip
    unless calculated_hmac == hmac_header
      head :unauthorized
    end
    request.body.rewind
  end

  def shop
    @shop ||= Shop.where(shopify_domain: request.headers['X-Shopify-Shop-Domain']).first
  end
end

