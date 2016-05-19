class BucketList < ActiveRecord::Base
  extend Paginate
  include Utilities

  has_many :items, dependent: :destroy
  belongs_to :user, foreign_key: :created_by

  validates :name, presence: true
  validates :created_by, presence: true
  
  def self.search(querry)
    where("LOWER(name) LIKE ?", "%#{querry.downcase}%")
  end
end
