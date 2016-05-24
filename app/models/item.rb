class Item < ActiveRecord::Base
  belongs_to :bucket_list

  validates :name, presence: true
end
