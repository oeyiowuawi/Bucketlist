class Api::V1::BucketlistsController < ApplicationController
  before_action :authenticate

  def create
    bucketlist_info = bucketlist_params.merge!({created_by: current_user.id})
    bucketlist = BucketList.new(bucketlist_info)
    if bucketlist.save
      render json: bucketlist, status: 201, root: false
    else
      render json: {message: "Bucketlist couldn't be created",
                    error: bucketlist.errors}, status: 422
    end
  end

  def index
    bucketlist = current_user.bucket_lists
    if bucketlist.empty?
      render json: {message: "You have no bucketlist"}, status: 200
    else
      render json: bucketlist, status: 200, root: false
    end
  end

  def show
    bucketlist = current_user.bucket_lists.find_by(id: bucketlist_params[:id])
    unless bucketlist.nil?
      render json: bucketlist, status: 200, root: false
    else
      render json: {message: "bucketlist not found"}, status: 404
    end
  end

  def update
    bucketlist = current_user.bucket_lists.find_by(id: bucketlist_params[:id])
    unless bucketlist.nil?
      if bucketlist.update_attributes(name: bucketlist_params[:name])
        render json: bucketlist, status: 200, root: false
      else
        render json: {errors: bucketlist.errors}, status: 422
      end
    else
      render json: {errors: "can't update an invalid bucketlist"}, status: 404
    end
  end

  def destroy
    bucketlist = current_user.bucket_lists.find_by(id: bucketlist_params[:id])
     unless bucketlist.nil?
      if bucketlist.destroy
        head 204
      else
        render json: {message: "Can`t delete the bucketlist, Try again"}, status: 500
      end
    else
      render json: {message: "bucketlist not found"}, status: 404
    end
  end


  private
  def bucketlist_params
    params.permit(:name, :id, :page, :limit, :q)
  end
end
