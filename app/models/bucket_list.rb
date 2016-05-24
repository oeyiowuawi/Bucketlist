class BucketList < ActiveRecord::Base
  extend Paginate

  has_many :items, dependent: :destroy
  belongs_to :user, foreign_key: :created_by

  validates :name, presence: true
  validates :created_by, presence: true

  def self.search(query)
    where("LOWER(name) LIKE ?", "%#{query.downcase}%")
  end
end
