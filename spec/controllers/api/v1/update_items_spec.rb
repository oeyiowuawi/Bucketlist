require 'rails_helper'

RSpec.describe 'when updating an item in a bucketlist', type: :request do
  before(:all) do
    @item = create(:item)
  end
  context 'valid request' do
    before(:each) do
      token = token_generator(@item.bucket_list.user)
      headers = {
        'HTTP_AUTHORIZATION' => token,
        'Content-Type' => 'application/json',
        'HTTP_ACCEPT' => 'application/vnd.bucketlist.v1'
      }
      put "/bucketlists/#{@item.bucket_list.id}/items/#{@item.id}",
          attributes_for(:item, name: 'Alan Padew', done: true).to_json, headers
    end

    it 'should return a status code of 200' do
      expect(response).to have_http_status 200
    end

    it 'should return the updated name' do
      expect(json['item']['name']).to eq 'Alan Padew'
    end
    it 'should return the updated done' do
      expect(json['item']['done']).to eq true
    end
  end
  context 'invalid request' do
    context 'when name is not provided' do
      before(:each) do
        token = token_generator(@item.bucket_list.user)
        headers = {
          'HTTP_AUTHORIZATION' => token,
          'Content-Type' => 'application/json',
          'HTTP_ACCEPT' => 'application/vnd.bucketlist.v1'
        }
        put "/bucketlists/#{@item.bucket_list.id}/items/#{@item.id}",
            attributes_for(:item, name: nil, done: true).to_json, headers
      end
      it 'should return a status code of 422' do
        expect(response).to have_http_status 422
      end
      it 'should return error message to the user' do
        expect(json['errors']['name']).to eq ["can't be blank"]
      end
    end

    context "when trying to update a bucketlist that doesn't belong to the user" do
      before(:each) do
        token = token_generator(@item.bucket_list.user)
        headers = {
          'HTTP_AUTHORIZATION' => token,
          'Content-Type' => 'application/json',
          'HTTP_ACCEPT' => 'application/vnd.bucketlist.v1'
        }
        put "/bucketlists/2/items/#{@item.id}",
            attributes_for(:item, name: @item.name, done: true).to_json, headers
      end
      it 'should return a 404 status code' do
        expect(response).to have_http_status 404
      end
    end
  end
end
