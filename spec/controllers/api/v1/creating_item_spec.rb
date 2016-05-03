# require "rails_helper"
#
# RSpec "when creating an item ", type: :request do
#   before(:all) do
#     @user = create(:user)
#     @bucketlist = create(:bucket_list, created_by: @user.id)
#   end
#   context "using a valid bucketlist" do
#     before(:each) do
#       @item = build(:item)
#       token = token_generator(@user)
#       headers = {
#         "HTTP_AUTHORIZATION" => token,
#         "Content-Type" => "application/json",
#         "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
#       }
#       post "/bucketlists/#{@bucketlist.id}/items", {
#         name: @item.name
#       }.to_json, headers
#     end
#   end
# end
