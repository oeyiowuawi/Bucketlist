module Paginate
  MAX_LIMIT = 100
  MIN_LIMIT = 20
  def generate_paginate(params)
    limit = set_limit(params[:limit].to_i)
    offset = params[:page] ? (params[:page].to_i - 1) * limit : 0
    limit(limit).offset(offset)
  end

  def set_limit(limit)
    if limit <= 0 || limit > MAX_LIMIT
      MIN_LIMIT
    else
      limit
    end
  end
end
