json.array!(@publications) do |publication|
  json.extract! publication, :id, :author, :author_image, :content, :resource_type, :resource, :twitter_id, :published
  json.url publication_url(publication, format: :json)
end
