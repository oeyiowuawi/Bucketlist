class BucketListSerializer < ActiveModel::Serializer
  attributes :id, :name, :items, :date_created, :date_modified, :created_by
  has_many :items

  def date_created
    object.created_at.strftime("%Y-%m-%d %l:%M:%S")
  end

  def date_modified
    object.updated_at.strftime("%Y-%m-%d %l:%M:%S")
  end
end
