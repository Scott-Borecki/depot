require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(title:       'My Book Title',
                          description: 'My Book Description',
                          image_url:   'my_image.jpg')

    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: 'My Book Title',
                description: 'My book description.',
                price: 1,
                image_url: image_url)
  end

  test 'image url' do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |image_url|
      assert new_product(image_url).valid?,
        "#{image_url} shouldn't be invalid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?,
        "#{image_url} shouldn't be valid"
    end
  end

  test 'product is not valid without a unique title = i18n' do
    product = Product.new(title:       products(:ruby).title,
                          description: 'yyy',
                          price:       1,
                          image_url:  'fred.gif')

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                 product.errors[:title]
  end

  test 'product title is at least 10 characters' do
    product_with_short_title = Product.new(
      title:       '2short',
      description: 'yyy',
      price:       1,
      image_url:  'fred.gif')

    assert product_with_short_title.invalid?,
      "#{product_with_short_title.title} shouldn't be valid"
      assert_equal ['must be at least 10 characters'],
        product_with_short_title.errors[:title]

    product_with_long_title = Product.new(
      title:       'This is Long Enough',
      description: 'yyy',
      price:       1,
      image_url:  'fred.gif')

    assert product_with_long_title.valid?,
      "#{product_with_long_title.title} should be valid"
  end
end
