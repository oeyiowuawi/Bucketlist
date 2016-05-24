class ItemSerializer < ActiveModel::Serializer
  include Utilities

  attributes :id, :name, :date_created, :date_modified, :done
end
