class Api::V1::ItemsController < ApplicationController
  before_action :authenticate
  include InvalidRequest
  def create
    bucketlist = current_user.bucket_lists.find_by(id: items_params[:bucketlist_id])
    return not_found if bucketlist.nil?
      item = bucketlist.items.new(items_params.except(:bucketlist_id))
      if item.save
        render json: item, status: 201
      else
        render json: {errors: item.errors}, status: 422
      end
  end

  private

  def items_params
    params.permit(:bucketlist_id, :name, :done)
  end
end
