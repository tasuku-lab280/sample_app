columns =  [
  { name: :link },
]
json.columns columns

json.data @articles do |one|
  link = link_to(article_path(one)) do
          content_tag(:p, one.body, class: 'card-title font-weight-bold')
        end
  
  columns.each do |column|
    value = case column[:name]
            when :link
              link
            else
              one.send(column[:name])
            end
    json.set! column[:name], value
  end
end
