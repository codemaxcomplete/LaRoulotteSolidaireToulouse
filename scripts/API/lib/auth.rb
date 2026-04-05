# scripts/API/lib/auth.rb
# frozen_string_literal: true

module AuthHelpers
  def require_api_token!
    expected = ENV["RLT_API_TOKEN"]
    return if expected.nil? || expected.empty? # mode ouvert si pas de token

    provided = request.env["HTTP_AUTHORIZATION"]&.sub(/^Bearer\s+/i, "")
    return if provided == expected

    json_error("unauthorized", 401, details: "Token invalide ou manquant")
  end
end
