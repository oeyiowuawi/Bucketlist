require 'rails_helper'
RSpec.describe 'when trying to update a bucketlist', type: :request do
  before(:all) do
    @user1 = create(:user)
    @user2 = create(:user)
    @bucketlist1 = create(:bucket_list, created_by: @user1.id)
    @bucketlist2 = create(:bucket_list, created_by: @user2.id)
  end

  context 'as a logged in user' do
    context 'that owns the bucketlist' do
      context 'Request with valid parameters' do
        before(:each) do
          token = token_generator(@user1)
          headers = {
            'HTTP_AUTHORIZATION' => token,
            'Content-Type' => 'application/json',
            'HTTP_ACCEPT' => 'application/vnd.bucketlist.v1'
          }
          put "/bucketlists/#{@bucketlist1.id}", {
            name: 'Alan Padew'
          }.to_json, headers
        end
        it 'returns a success status code' do
          expect(response).to have_http_status 200
        end

        it 'returns the updated object' do
          expect(json['name']).to eq 'Alan Padew'
        end
      end
      context 'Request with invalid Parameter' do
        before(:each) do
          token = token_generator(@user1)
          headers = {
            'HTTP_AUTHORIZATION' => token,
            'Content-Type' => 'application/json',
            'HTTP_ACCEPT' => 'application/vnd.bucketlist.v1'
          }
          put "/bucketlists/#{@bucketlist1.id}", {
            name: nil
          }.to_json, headers
        end
        it 'returns a status code of 422' do
          expect(response).to have_http_status 422
        end
        it 'return the appropriate error message to the user' do
          expect(json['errors']['name']).to eq ["can't be blank"]
        end
      end
    end

    context "that doesn't belong to the user," do
      before(:each) do
        token = token_generator(@user1)
        headers = {
          'HTTP_AUTHORIZATION' => token,
          'Content-Type' => 'application/json',
          'HTTP_ACCEPT' => 'application/vnd.bucketlist.v1'
        }
        put "/bucketlists/#{@bucketlist2.id}", {
          name: 'Alan Padew'
        }.to_json, headers
      end

      it 'returns a 404 status code' do
        expect(response).to have_http_status 404
      end

      it 'returns a message to the User' do
        expect(json['errors']).to include "can't update an invalid bucketlist"
      end
    end
  end
end
