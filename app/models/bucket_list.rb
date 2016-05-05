class BucketList < ActiveRecord::Base
  belongs_to :user, foreign_key: :created_by
  validates :name, presence: true
  validates :created_by, presence: true
  has_many :items
end
