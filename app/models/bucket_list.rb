class BucketList < ActiveRecord::Base

  validates :name, presence: true
  validates :created_by, presence: true
end
