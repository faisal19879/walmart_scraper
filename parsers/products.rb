nokogiri = Nokogiri.HTML(content)

# initialize an empty hash
product = {}

#extract title
product['title'] = nokogiri.at_css('.ProductTitle').text.strip

#extract current price
product['current_price'] = nokogiri.at_css('span.price-characteristic').attr('content').to_f

#extract original price
original_price_div = nokogiri.at_css('.price-old')
original_price = original_price_div ? original_price_div.text.strip.gsub('$','').to_f : nil
product['original_price'] = original_price == 0.0 ? nil : original_price

#extract rating
rating = nokogiri.at_css('.hiddenStarLabel .seo-avg-rating').text.strip.to_f
product['rating'] = rating == 0 ? nil : rating

#extract number of reviews
review_text = nokogiri.at_css('.stars-reviews-count-node').text.strip
product['reviews_count'] = review_text =~ /reviews/ ? review_text.split(' ').first.to_i : 0

#extract publisher
product['publisher'] = nokogiri.at_css('a.prod-brandName').text.strip

#extract walmart item number
product['walmart_number'] = nokogiri.at_css('.prod-productsecondaryinformation .wm-item-number').text.split('#').last.strip

#extract product image
product['img_url'] = nokogiri.at_css('.prod-hero-image img')['src'].split('?').first

#extract product categories
product['categories'] = nokogiri.css('.breadcrumb-list li').collect{|li| li.text.strip.gsub('/','') }

# specify the collection where this record will be stored
product['_collection'] = 'products'

# save the product to the job’s outputs
outputs << product