require 'test_helper'

class ProductTest < ActiveSupport::TestCase
     fixtures :products
     test "свойтсва товара не должны быть пустыми" do
     #product attributes must not be empty
    	 product = Product.new
     	 assert product.invalid?
     	 assert product.errors[:title].any?
     	 assert product.errors[:description].any?
     	 assert product.errors[:price].any?
     	 assert product.errors[:image_url].any?
     	 assert !product.valid?
     end

     test "Цена товара должна быть положительной" do
         product = Product.new(title: "My book Title",
    	 					   description: "yyy",
    	 				       image_url: "zzz.jpg")
    	 product.price = -1
    	 assert product.invalid?
   		 assert_equal ["Должна быть больше либо равна 0.01"], 
   		 product.errors[:price]
    
   		 product.price = 0
    	 assert product.invalid?
    	 assert_equal ["Должна быть больше либо равна 0.01"], 
    	 product.errors[:price]

    	 product.price = 1
    	 assert product.valid?
     end

     def new_product(image_url)
     	Product.new(title: "My book Title",
     			    description: "yyy",
     			    price: 1,
     			    image_url: image_url)
     end

     test "url изображения" do 
     	ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg 
     	         http://a.b.c/x/y/z/fred.gif }
     	bad = %w{ fred.doc fred.gif/more fred.gif.more }

     	ok.each do |name|
     		assert new_product(name).valid?, "#{name} не должно быть неприемлемым"
     	end

     	bad.each do |name|
     		 assert new_product(name).invalid?, "#{name} не должно быть приемлемым"
     	end
    end 

    test "Если у товара нет уникального названия, то он недоступен - i18n" do
    	product = Product.new(title: products(:ruby).title,
    						  description: "yyy",
    						  price: 1,
    						  image_url: "fred.gif")

    	assert product.invalid?

    	assert_equal [I18n.translate('activerecord.errors.messeges.taken')], product.errors(:title)
    end
end
