module InvalidRequest
  extend ActiveSupport::Concern

  included do
    before_action :validate_bucketlist
    before_action :validate_bucketlist_item if controller_name == "items"
  end

  def validate_bucketlist
    id = controller_name == "items" ? params[:bucketlist_id] : params[:id]
    @bucketlist = current_user.bucket_lists.find_by(id: id)
    return not_found if @bucketlist.nil?
  end

  def validate_bucketlist_item
    @item = @bucketlist.items.find_by(id: items_params[:id])
    return not_found if @item.nil?
  end

  def not_found
    render json: { errors: "Cannot locate the resource" }, status: 404
  end
end
