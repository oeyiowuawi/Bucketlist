class CreateBucketLists < ActiveRecord::Migration
  def change
    create_table :bucket_lists do |t|
      t.string :name
      t.integer :created_by

      t.timestamps null: false
    end
  end
end
