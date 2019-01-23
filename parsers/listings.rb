nokogiri = Nokogiri.HTML(content)

#load products
products = nokogiri.css('#list-items li')
products.each do |product|
  a_element = product.at_css('a.product')
  if a_element
    url = URI.join('https:', a_element['href']).to_s
    if url =~ /\Ahttps?:\/\//i
      pages << {
          url: url,
          page_type: 'products',
          vars: {
            url: url
          }
        }
    end
  end
end

#load paginated links
pagination_links = nokogiri.css('#pagination-bottom a')
pagination_links.each do |link|
  url = URI.join('https:', a_element['href']).to_s
  pages << {
      url: url,
      page_type: 'listings',
      vars: {}
    }
end
