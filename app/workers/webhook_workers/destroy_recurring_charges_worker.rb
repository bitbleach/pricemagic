class DestroyRecurringChargesWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15

  def perform(shop_id)
    shop = Shop.find(shop_id)
    shop.recurring_charges.destroy_all
  end
end