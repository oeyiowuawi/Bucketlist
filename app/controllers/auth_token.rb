class AuthToken
  def self.encode(payload, ttl_in_minutes = 60 * 24 * 1)
    payload[:exp] = ttl_in_minutes.minutes.from_now.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    lway = { leeway: nil }
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, lway)
    HashWithIndifferentAccess.new(decoded[0])
  end
end
