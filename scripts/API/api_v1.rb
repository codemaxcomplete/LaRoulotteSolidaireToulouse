# scripts/API/api_v1.rb
# frozen_string_literal: true

require "sinatra/namespace"

module RoulotteAPI
  module V1
    def self.registered(app)
      app.namespace "/api/v1" do
        before do
          require_api_token!
        end

        # Exemple : ping
        get "/ping" do
          json_ok(message: "pong", time: Time.now.utc.iso8601)
        end

        # Exemple : notes de route (fichier partagé avec tes scripts Python)
        NOTES_FILE = File.expand_path("../notes_route.txt", __dir__)

        get "/notes" do
          notes = if File.exist?(NOTES_FILE)
                    File.read(NOTES_FILE, encoding: "UTF-8").lines.map(&:chomp)
                  else
                    []
                  end
          json_ok(notes: notes)
        end

        post "/notes" do
          payload = JSON.parse(request.body.read) rescue {}
          text = payload["text"].to_s.strip
          halt json_error("bad_request", 400, details: "Texte manquant") if text.empty?

          ts = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          File.open(NOTES_FILE, "a:utf-8") { |f| f.puts "[#{ts}] #{text}" }

          json_ok(message: "Note ajoutée", text: text, timestamp: ts)
        end

        # Exemple : proxy vers un script de maintenance (Bash/Python)
        post "/maintenance/run" do
          script = File.expand_path("../maintenance_roulotte.sh", __dir__)
          unless File.executable?(script)
            json_error("script_not_found", 500, details: "Script maintenance introuvable ou non exécutable")
          end

          # Ici on pourrait accepter des options dans le JSON
          system(script, "--all", "--non-interactif", "--cron")
          json_ok(message: "Maintenance lancée")
        end
      end
    end
  end
end
