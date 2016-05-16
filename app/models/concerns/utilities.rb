module Utilities
  def date_created
    created_at.strftime("%Y-%m-%d %l:%M:%S")
  end

  def date_modified
    updated_at.strftime("%Y-%m-%d %l:%M:%S")
  end
end
