module InvalidRequest
  extend ActiveSupport::Concern
  def not_found
    render json: {errors: "Cannot locate the resource", status: 404}
  end
end
