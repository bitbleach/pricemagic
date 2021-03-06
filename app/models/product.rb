class Product < ActiveRecord::Base
  belongs_to :shop
  has_many :variants, ->{ order(:created_at) }, dependent: :destroy
  has_many :price_tests, dependent: :destroy
  has_many :metrics, ->{ order(:created_at) }, dependent: :destroy 
  has_many :collects, dependent: :destroy
  has_many :collections, through: :collects

  validates :shop_id, presence: true
  validates :shopify_product_id, uniqueness: true
  # ## TODO change name to be more descriptive
  # ## Should be singular, most_recent_google_metric?

  def delete_collects
    shop.collects.where(product_id: id).destroy_all
  end

  def variant_unit_cost_hash
    hash = Hash.new
    variants.each {|var| hash[var.id] = var.unit_cost}
    hash
  end
  
  def most_recent_metrics
    variants.includes(:metrics).select{ |m| m if m.metrics.any? }.map {|m| m.metrics.last}
  end
  
  def first_variant_price
    main_variant.variant_price
  end
  
  def main_variant
    variants.first
  end
  
  def latest_product_google_metric_views
    main_variant.metrics.last.try(:page_views).to_i
  end

  def latest_product_google_metric_views_at(date)
    main_variant.metrics.where('created_at < ?', date).last.try(:page_views).to_i
  end
  
  def has_active_price_test?
    price_tests.empty? ? "Inactive" : price_test_active_true_to_active_conversion #price_tests.last.active.to_s.capitalize
  end
  alias_method :has_active_price_test, :has_active_price_test?
  
  def price_test_completion_percentage
    price_tests.any? ? price_tests.last.completion_percentage : 0
  end

  def price_test_active_true_to_active_conversion
    price_tests.last.active == true ? "Active" : "Inactive"
  end

  def as_json(options={})
    super(:methods => [:variants, :has_active_price_test, :price_test_completion_percentage])
  end

end
