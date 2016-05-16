module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate
      include Validators
      skip_before_action :validate_bucketlist_item, only: :create

      def create
        item = @bucketlist.items.new(items_params.except(:bucketlist_id))
        if item.save
          render json: item, status: 201
        else
          render json: { errors: item.errors }, status: 422
        end
      end

      def update
        if @item.update(items_params.except(:bucketlist_id))
          render json: @item, status: 200
        else
          render json: { errors: @item.errors }, status: 422
        end
      end

      def destroy
        @item.destroy
        head 204
      end

      private

      def items_params
        params.permit(:bucketlist_id, :name, :done, :id)
      end
    end
  end
end
