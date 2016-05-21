module Validators
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      render json: { errors: messages.resource_not_found }, status: 404
    end
    before_action :validate_bucketlist
    before_action :validate_bucketlist_item if controller_name == "items"
  end

  def validate_bucketlist
    id = controller_name == "items" ? params[:bucketlist_id] : params[:id]
    @bucketlist = current_user.bucket_lists.find(id)
  end

  def validate_bucketlist_item
    @item = @bucketlist.items.find(items_params[:id])
  end
end
