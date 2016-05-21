class AuthToken
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
  end

  def self.decode(token)
    decoded_token = JWT.decode(
      token, Rails.application.secrets.secret_key_base,
      true,
      algorithm: "HS256"
    )
    HashWithIndifferentAccess.new(decoded_token[0])
  end
end
