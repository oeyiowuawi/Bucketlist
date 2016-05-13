module Request
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def token_generator(user)
      AuthToken.encode({ user_id: user.id }, 3600)
    end
  end
end
