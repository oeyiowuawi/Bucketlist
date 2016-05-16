class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :date_created, :date_modified, :done
end
