class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :date_created, :date_modified
end
