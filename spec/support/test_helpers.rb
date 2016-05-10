module Request
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def token_generator(user)
      post "/auth/login", email: user.email,
                          password: user.password
      json["auth_token"]
    end

    def valid_get_request(url, user)
      headers = {
        "HTTP_AUTHORIZATION" => token_generator(user),
        "Content-Type" => "application/json",
        "HTTP_ACCEPT" => "application/vnd.bucketlist.v1"
      }
      get url, {}, headers
    end
  end
end
