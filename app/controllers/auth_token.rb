class AuthToken
  def self.encode(payload, ttl_in_minutes = 60 * 24 * 1)
    payload[:exp] = ttl_in_minutes.minutes.from_now.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, true,
                         algorithm: "HS256")
    HashWithIndifferentAccess.new(decoded[0])
  end
end
