module Api
  module V1
    class BucketlistsController < ApplicationController
      before_action :authenticate
      include Validators
      include ResourceHelpers
      before_action :search_bucketlist, only: :index
      skip_before_action :validate_bucketlist, only: [:create, :index]

      def create
        bucketlist = current_user.bucket_lists.new(bucketlist_params)
        puts bucketlist_params
        create_helper(bucketlist)
      end

      def index
        if @bucketlists.empty?
          render json: { errors: messages.no_result_found }, status: 404
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
        update_helper(@bucketlist, name: bucketlist_params[:name])
      end

      def destroy
        destroy_helper(@bucketlist)
      end

      private

      def bucketlist_params
        params.permit(:name, :id, :page, :limit)
      end

      def search_bucketlist
        query = params[:q]
        bucketlists = current_user.bucket_lists
        if bucketlists.empty?
          render json: { message: messages.no_bucket_list }, status: 200
        else
          @bucketlists = query ? bucketlists.search(query) : bucketlists
        end
      end
    end
  end
end
