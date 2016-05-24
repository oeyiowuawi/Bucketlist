class UserSerializer < ActiveModel::Serializer
  include Utilities

  attributes :id, :name, :email, :date_created, :date_modified
end
