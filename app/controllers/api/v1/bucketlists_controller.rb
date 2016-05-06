module Api
  module V1
    class BucketlistsController < ApplicationController
      before_action :authenticate
      before_action :search_bucketlist, only: :index
      before_action :validate_bucketlist, only: [:show, :update, :destroy]
      include InvalidRequest

      def create
        bucketlist_info = bucketlist_params.merge!(created_by: current_user.id)
        bucketlist = BucketList.new(bucketlist_info)
        if bucketlist.save
          render json: bucketlist, status: 201, root: false
        else
          render json: { message: "Bucketlist couldn't be created",
                         error: bucketlist.errors }, status: 422
        end
      end

      def index
        if @bucketlist.empty?
          render json: { errors: "No result found" }, status: 404
        else
          render json: @bucketlist, status: 200, root: false
        end
      end

      def show
        render json: @bucketlist, status: 200, root: false
      end

      def update
        if @bucketlist.update_attributes(name: bucketlist_params[:name])
          render json: @bucketlist, status: 200, root: false
        else
          render json: { errors: @bucketlist.errors }, status: 422
        end
      end

      def destroy
        @bucketlist.destroy
        head 204
      end

      private

      def bucketlist_params
        params.permit(:name, :id, :page, :limit)
      end

      def validate_bucketlist
        @bucketlist = current_user.bucket_lists.find_by(id: params[:id])
        return not_found if @bucketlist.nil?
      end

      def search_bucketlist
        q = params[:q]
        bucketlist = current_user.bucket_lists
        if bucketlist.empty?
          render json: { message: "You have no bucketlist" }, status: 200
        else
          @bucketlist = q ? current_user.bucket_lists.search(q) : bucketlist
        end
      end
    end
  end
end
