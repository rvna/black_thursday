require './test/test_helper'
require './lib/sales_engine'

class InvoiceTest < Minitest::Test

  def test_that_it_has_an_id
    invoice = Invoice.new({ id: 10, customer_id: 2, merchant_id: 12334839, status: "pending", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal 10, invoice.id
  end

  def test_that_it_has_a_customer_id
    invoice = Invoice.new({ id: 10, customer_id: 2, merchant_id: 12334839, status: "pending", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal 2, invoice.customer_id
  end

  def test_that_it_has_a_merchant_id
    invoice = Invoice.new({ id: 10, customer_id: 2, merchant_id: 12334839, status: "pending", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal 12334839, invoice.merchant_id
  end

  def test_that_it_has_a_status
    invoice = Invoice.new({ id: 10, customer_id: 2, merchant_id: 12334839, status: "pending", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal :pending, invoice.status
  end

  def test_that_it_finds_when_created
    invoice = Invoice.new({ id: 10, customer_id: 2, merchant_id: 12334839, status: "pending", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal Time.new(2016, 07, 26, 02, 23, 16, "-00:00"), invoice.created_at
  end

  def test_that_it_finds_when_updated
    invoice = Invoice.new({ id: 10, customer_id: 2, merchant_id: 12334839, status: "pending", created_at: "2016-07-26 02:23:16 UTC", updated_at: "1970-04-01 12:45:13 UTC" })

    assert_equal Time.new(1970, 04, 01, 12, 45, 13, "-00:00"), invoice.updated_at
  end

  def test_an_invoice_points_to_its_merchant
    se = SalesEngine.from_csv({ items: "./test/samples/item_sample.csv", merchants: "./test/samples/merchants_sample.csv", invoices: "./test/samples/invoices_sample.csv" })
    invoice = se.invoices.find_by_id(100)

    assert_equal 12334266, invoice.merchant.id
  end

  def test_an_invoice_points_to_its_transactions
    se = SalesEngine.from_csv({ invoices: "./test/samples/invoices_sample.csv", transactions: "./test/samples/transactions_sample.csv"})
    invoice = se.invoices.find_by_id(46)

    assert_equal true, invoice.transactions.is_a?(Array)
    assert_equal 2, invoice.transactions.length
    assert_equal 2, invoice.transactions[0].id
  end

  def test_an_invoice_points_to_its_customer
    se = SalesEngine.from_csv({ invoices: "./test/samples/invoices_sample.csv", customers: "./test/samples/customers_sample.csv"})
    invoice = se.invoices.find_by_id(17)

    assert_equal true, invoice.customer.is_a?(Customer)
    assert_equal "Sylvester", invoice.customer.first_name
  end

  def test_an_invoice_points_to_its_items
    se = SalesEngine.from_csv({ invoices: "./test/samples/invoices_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv", items: "./test/samples/item_sample.csv"})
    invoice = se.invoices.find_by_id(3)

    assert_equal true, invoice.items.is_a?(Array)
    assert_equal 1, invoice.items.length
    assert_equal "510+ RealPush Icon Set", invoice.items[0].name
  end

  def test_that_it_can_return_an_array_of_transaction_statuses
    se = SalesEngine.from_csv({ invoices: "./test/samples/invoices_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv", items: "./test/samples/item_sample.csv", transactions: "./test/samples/transactions_sample.csv"})
    invoice = se.invoices.find_by_id(46)
    transactions = invoice.transactions

    assert_equal true, invoice.check_results(transactions).is_a?(Array)
    assert_equal 1, invoice.check_results(transactions).length
  end

  def test_that_it_can_determine_if_invoice_is_paid_in_full
    se = SalesEngine.from_csv({ invoices: "./test/samples/invoices_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv", items: "./test/samples/item_sample.csv", transactions: "./test/samples/transactions_sample.csv"})
    invoice1 = se.invoices.find_by_id(46)
    invoice2 = se.invoices.find_by_id(14)

    assert_equal true, invoice1.is_paid_in_full?
    assert_equal false, invoice2.is_paid_in_full?
  end

  def test_that_invoice_can_point_to_its_invoice_items
    se = SalesEngine.from_csv({ invoices: "./test/samples/invoices_sample.csv", customers: "./test/samples/customers_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv" })
    invoice = se.invoices.find_by_id(2)

    assert_equal true, invoice.invoice_items.is_a?(Array)
    assert_equal 4, invoice.invoice_items.length
  end

  def test_total_calculates_total_invoice_amount
    se = SalesEngine.from_csv({ invoices: "./test/samples/invoices_sample.csv", customers: "./test/samples/customers_sample.csv", invoice_items: "./test/samples/invoice_items_sample.csv" })
    invoice = se.invoices.find_by_id(2)

    assert_equal BigDecimal(5289.13, 6), invoice.total
  end


end
