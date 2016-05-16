module Utilities
  def date_created
    self.created_at.strftime("%Y-%m-%d %l:%M:%S")
  end

  def date_modified
    self.updated_at.strftime("%Y-%m-%d %l:%M:%S")
  end
end
