class DestroyRecurringChargesWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(shop_id)
    shop = Shop.find(shop_id)
    shop.recurring_charges.delete_all
  end
end