module Utilities
  def date_created
    object.created_at.strftime("%Y-%m-%d %l:%M:%S")
  end

  def date_modified
    object.updated_at.strftime("%Y-%m-%d %l:%M:%S")
  end
end
