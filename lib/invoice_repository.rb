require_relative '../lib/invoice'

class InvoiceRepository
  attr_reader :list_of_invoices,
              :parent_engine

  extend Forwardable
  def_delegators :@parent_engine, :find_merchant,
                                  :find_transactions,
                                  :find_customer,
                                  :find_items_from_invoice


  def initialize(invoices_data, parent_engine)
    @parent_engine = parent_engine
    @list_of_invoices = populate_invoices(invoices_data)
  end

  def populate_invoices(invoices_data)
    invoices_data.map do |datum|
      Invoice.new(datum, self)
    end
  end

  def all
    list_of_invoices
  end

  def find_by_id(id_to_find)
    list_of_invoices.find do |invoice|
      invoice.id == id_to_find
    end
  end

  def find_all_by_customer_id(customer_id_to_find)
    list_of_invoices.find_all do |invoice|
      invoice.customer_id == customer_id_to_find
    end
  end

  def find_all_by_merchant_id(merchant_id_to_find)
    list_of_invoices.find_all do |invoice|
      invoice.merchant_id == merchant_id_to_find
    end
  end

  def find_all_by_status(status_to_find)
    list_of_invoices.find_all do |invoice|
      invoice.status == status_to_find
    end
  end

  def return_all_customers_for_merchant(merchant_id)
    find_all_by_merchant_id(merchant_id).map do |invoice|
      invoice.customer
    end.reject { |elem| elem.nil? }
  end

  def return_all_merchants_for_customer(customer_id)
    find_all_by_customer_id(customer_id).map do |invoice|
      invoice.merchant
    end.reject { |elem| elem.nil? }
  end

#just for the spec harness
  def inspect
  end

end
