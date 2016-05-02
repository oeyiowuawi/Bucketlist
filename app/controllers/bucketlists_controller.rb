class BucketlistsController < ApplicationController
  before_action :authenticate
  def create
    bucketlist_info = bucketlist_params.merge!({created_by: current_user.id})
    bucketlist = BucketList.new(bucketlist_info)
    if bucketlist.save
      render json: bucketlist, status: 201 #, location: bucketlist_path(bucketlist.id)
    else
      render json: {message: "Bucketlist couldn't be created",
                    error: bucketlist.errors}, status: 422
    end
  end
  private
  def bucketlist_params
    params.permit(:name, :id, :page, :limit, :q)
  end
end
