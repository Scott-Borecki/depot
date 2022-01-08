class AddUnitPriceToLineItems < ActiveRecord::Migration[6.0]
  def up
    add_column :line_items, :unit_price, :decimal, precision: 8, scale: 2

    # update the unit price for line items where nil
    # and replace with the price of the product
    line_items_without_unit_price = LineItem.where(unit_price: nil)

    line_items_without_unit_price.each do |line_item|
      product_price = line_item.product.price
      line_item.unit_price = product_price
      line_item.save!
    end
  end

  def down
    remove_column :line_items, :unit_price
  end
end
