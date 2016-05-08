

ActiveRecord::Schema.define(version: 20_160_503_213_419) do
  create_table 'bucket_lists', force: :cascade do |t|
    t.string   'name'
    t.integer  'created_by'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'items', force: :cascade do |t|
    t.string   'name'
    t.boolean  'done', default: false
    t.integer  'bucket_list_id'
    t.datetime 'created_at',                     null: false
    t.datetime 'updated_at',                     null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string   'name'
    t.string   'email'
    t.datetime 'created_at',                      null: false
    t.datetime 'updated_at',                      null: false
    t.string   'password_digest'
    t.boolean  'active_status', default: false
  end

  add_index 'users', ['email'], name: 'index_users_on_email', unique: true
end
