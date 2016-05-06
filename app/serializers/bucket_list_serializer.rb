class BucketListSerializer < ActiveModel::Serializer
  attributes :id, :name, :items, :date_created, :date_modified
  has_many :items

  def date_created
    object.created_at.strftime('%Y-%m-%d %l:%M:%S')
  end

  def date_modified
    object.updated_at.strftime('%Y-%m-%d %l:%M:%S')
  end
end
