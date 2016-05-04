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

  def update
    bucketlist = current_user.bucket_lists.find_by(id: items_params[:bucketlist_id])
    return not_found if bucketlist.nil?

    item = bucketlist.items.find_by(id: items_params[:id])
    return not_found if item.nil?

    if item.update(items_params.except(:bucketlist_id))
      render json: item, status: 200
    else
      render json: {errors: item.errors}, status: 422
    end
  end

  private

  def items_params
    params.permit(:bucketlist_id, :name, :done, :id)
  end
end
