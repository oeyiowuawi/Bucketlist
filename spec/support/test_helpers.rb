module Request
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end
end
