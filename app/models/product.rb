class Product < ActiveRecord::Base
  belongs_to :shop
  has_many :variants, dependent: :destroy
  has_many :price_tests, dependent: :destroy
  has_many :metrics, dependent: :destroy
  has_many :collects
  has_many :collections, through: :collects
  
    # Other validations
  # TODO add validation to make sure shopify_product_id is unique
  
  validates :shop_id, presence: true
  
  def google_metrics
    ## TODO better way than shifting through unneccesary nils?
    metrics = self.variants.map {|m| m.metrics.last}
    metrics.compact
  end
  
  def main_product_google_metric
    self.variants.first.metrics.last
  end
end
