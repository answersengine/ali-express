nokogiri = Nokogiri.HTML(content)

# initialize an empty hash
product = {}

#save the url
product['url'] = page['vars']['url']

#extract title
product['title'] = nokogiri.at_css('.product-name').text.strip

#extract discount price
discount_element = nokogiri.at_css('span#j-sku-discount-price')
if discount_element
  discount_low_price = discount_element.css('span').find{|span| span['itemprop'] == 'lowPrice' }
  if discount_low_price
    product['discount_low_price'] = discount_element.css('span').find{|span| span['itemprop'] == 'lowPrice' }.text.to_f
    product['discount_high_price'] = discount_element.css('span').find{|span| span['itemprop'] == 'highPrice' }.text.to_f
  else
    product['discount_price'] = discount_element.text.to_f
  end
end

#extract categories
breadcrumb_categories = nokogiri.at_css('.ui-breadcrumb').text.strip
categories = breadcrumb_categories.split('>').map{|category| category.strip }
categories.delete('Home')
product['categories'] = categories

#extract SKUs
skus_element = nokogiri.css('ul.sku-attr-list').find{|ul| ul['data-sku-prop-id'] == '14' }
if skus_element
  skus = skus_element.css('a').collect{|a| a['title'] }
  product['skus'] = skus
end

#extract sizes
sizes_element = nokogiri.css('ul.sku-attr-list').find{|ul| ul['data-sku-prop-id'] == '5' }
if sizes_element
  sizes = sizes_element.css('a').collect{|a| a.text.strip }
  product['sizes'] = sizes
end

#extract rating and reviews
rating_element = nokogiri.at_css('span.ui-rating-star')
if rating_element
  product['rating'] = rating_element.css('span').find{|span| span['itemprop'] == 'ratingValue' }.text.strip.to_f
  product['reviews_count'] = rating_element.css('span').find{|span| span['itemprop'] == 'reviewCount' }.text.strip.to_i
end

#extract orders count
order_count_element = nokogiri.at_css('#j-order-num')
if order_count_element
  product['orders_count'] = order_count_element.text.strip.split(' ').first.to_i
end

#extract shipping info
#shipping_element = nokogiri.at_css('dl#j-product-shipping')
#if shipping_element
  #looks like this is added with javascript
  #raise shipping_element.text.inspect
#end

#extract return policy
return_element = nokogiri.at_css('#j-seller-promise-list')
if return_element
  product['return_policy'] = return_element.at_css('.s-serve').text.strip
end

#extract guarantee
#may require javascript
#guarantee_element = nokogiri.at_css('#serve-guarantees-detail')
#if guarantee_element
#  raise guarantee_element.text.strip.inspect
#end

# specify the collection where this record will be stored
product['_collection'] = "products"

# save the product to the job’s outputs
outputs << product
