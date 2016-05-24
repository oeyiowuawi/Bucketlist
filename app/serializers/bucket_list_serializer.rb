class BucketListSerializer < ActiveModel::Serializer
  include Utilities
<<<<<<< HEAD

=======
  
>>>>>>> master
  attributes :id, :name, :items, :date_created, :date_modified, :created_by
  has_many :items
end
