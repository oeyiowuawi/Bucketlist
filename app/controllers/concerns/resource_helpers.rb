module ResourceHelpers
  def create_helper(object)
    if object.save
      render json: object, status: 201, root: false
    else
      render json: { errors: object.errors }, status: 422
    end
  end

  def update_helper(object, params)
    if object.update_attributes(params)
      render json: object, status: 200, root: false
    else
      render json: { errors: object.errors }, status: 422
    end
  end

  def destroy_helper(object)
    object.destroy
    render json: { message: messages.deleted }, status: 200
  end
end
