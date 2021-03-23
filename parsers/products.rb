nokogiri = Nokogiri.HTML(content)

# initialize an empty hash
product = {}

#extract title
product['title'] = nokogiri.at_css('.prod-ProductTitle').attr('content').strip

#extract current price
product['current_price'] = nokogiri.at_css('.price-characteristic').attr('content').to_f

#extract original price
original_price_div = nokogiri.at_css('.price .visuallyhidden')
original_price = original_price_div ? original_price_div.to_s.match(/\d+.\d+/) : nil
product['original_price'] = original_price == '0.0' ? nil : original_price

#extract rating
rating = nokogiri.at_css('.stars-container').attr('aria-label').match(/^\d*/)
product['rating'] = rating == "0" ? nil : rating

#extract number of reviews
ratenum = nokogiri.at_css('.stars-reviews-count-node')
product['reviews_count'] = ratenum.to_s.split.last == "ratings" ? ratenum.to_s.split.first : "0"

#extract publisher
product['publisher'] = nokogiri.at_css('a.prod-brandName span').to_s.strip

#extract walmart item number
product['walmart_number'] = nokogiri.at_css('.valign-middle.secondary-info-margin-right').text.split('#').last.strip

#extract product image
product['img_url'] = "https:"+nokogiri.at_css('.prod-hero-image-image').attr("src").split('?').first

# specify the collection where this record will be stored
product['_collection'] = 'products'

# save the product to the job’s outputs
outputs << product