class TagSerializer
  include JSONAPI::Serializer
  attributes :name, :taggings_count
end
