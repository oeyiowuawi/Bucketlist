module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate
      include Validators
      include ResourceHelpers
      skip_before_action :validate_bucketlist_item, only: :create

      def create
        item = @bucketlist.items.new(items_params.except(:bucketlist_id))
        create_helper(item)
      end

      def update
        update_helper(@item, items_params.except(:bucketlist_id))
      end

      def destroy
        destroy_helper(@item)
      end

      private

      def items_params
        params.permit(:bucketlist_id, :name, :done, :id)
      end
    end
  end
end
