module Request
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def token_generator
      user = create(:user)
      post "/auth/login", {
        email: user.email,
        password: user.password
      }
      json["auth_token"]
    end
  end
end
