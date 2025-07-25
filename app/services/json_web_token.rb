require "jwt"

class JsonWebToken
    SECRET_KEY = Rails.application.credentials.secret_key_base || ENV["SECRET_KEY_BASE"]

    def self.encode(payload)
        payload[:exp] = 24.hours.from_now.to_i
        JWT.encode(payload, SECRET_KEY, "HS256")
    end

    def self.decode(token)
        decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
        HashWithIndifferentAccess.new(decoded.first)
    rescue JWT::DecodeError => e
        Rails.logger.warn("JWT Decode failed: #{e.message}")
        nil
    end
end
