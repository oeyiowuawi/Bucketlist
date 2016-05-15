module Request
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def token_generator(user)
      AuthToken.encode({ user_id: user.id }, 1.minutes.from_now)
    end
  end
end
