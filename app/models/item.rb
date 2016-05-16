class Item < ActiveRecord::Base
  include Utilities
  belongs_to :bucket_list

  validates :name, presence: true
end
