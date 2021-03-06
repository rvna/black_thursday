require_relative '../lib/sales_engine'
require_relative '../lib/merchant_analyst'
require_relative '../lib/item_analyst'
require_relative '../lib/invoice_analyst'
require_relative '../lib/customer_analyst'

class SalesAnalyst
  attr_reader :sales_engine,
              :item_analyst,
              :merchant_analyst,
              :invoice_analyst,
              :customer_analyst

  extend Forwardable

  def_delegators :@item_analyst, :golden_items

  def_delegators :@merchant_analyst,
                   :average_items_per_merchant,
                   :average_items_per_merchant_standard_deviation,
                   :merchants_with_high_item_count,
                   :average_item_price_for_merchant,
                   :average_average_price_per_merchant,
                   :average_invoices_per_merchant,
                   :average_invoices_per_merchant_standard_deviation,
                   :top_merchants_by_invoice_count,
                   :bottom_merchants_by_invoice_count

  def_delegators :@invoice_analyst,  :top_days_by_invoice_count,
                                     :invoice_status,
                                     :best_invoice_by_revenue,
                                     :best_invoice_by_quantity

  def_delegators :@customer_analyst,
                   :top_buyers,
                   :top_merchant_for_customer,
                   :one_time_buyers,
                   :one_time_buyers_items,
                   :items_bought_in_year,
                   :customers_with_unpaid_invoices



  def initialize(sales_engine)
    @sales_engine = sales_engine
    @item_analyst = ItemAnalyst.new(all_items)
    @merchant_analyst = MerchantAnalyst.new(all_merchants)
    @invoice_analyst = InvoiceAnalyst.new(all_invoices)
    @customer_analyst = CustomerAnalyst.new(all_customers)
  end

  def all_merchants
    sales_engine.merchants.all
  end

  def all_items
    sales_engine.items.all
  end

  def all_invoices
    sales_engine.invoices.all
  end

  def all_customers
    sales_engine.customers.all
  end

end
