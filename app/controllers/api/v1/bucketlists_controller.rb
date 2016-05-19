module Api
  module V1
    class BucketlistsController < ApplicationController
      before_action :authenticate
      before_action :search_bucketlist, only: :index
      include Validators
      skip_before_action :validate_bucketlist, only: [:create, :index]

      def create
        bucketlist = current_user.bucket_lists.new(bucketlist_params)
        if bucketlist.save
          render json: bucketlist, status: 201, root: false
        else
          render(
            json: { message: "Bucketlist couldn't be created",
                    error: bucketlist.errors },
            status: 422
          )
        end
      end

      def index
        if @bucketlists.empty?
          render json: { errors: "No result found" }, status: 404
        else
          render(
            json: @bucketlists.paginate(params),
            status: 200,
            root: false
          )
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
        render json: { message: "Successfully deleted" }, status: 200
      end

      private

      def bucketlist_params
        params.permit(:name, :id, :page, :limit)
      end

      def search_bucketlist
        querry = params[:q]
        bucketlist = current_user.bucket_lists
        if bucketlist.empty?
          render json: { message: "You have no bucketlist" }, status: 200
        else
          @bucketlists = querry ? bucketlist.search(querry) : bucketlist
        end
      end
    end
  end
end
