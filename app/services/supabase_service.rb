require 'httparty'

class SupabaseService
  include HTTParty
  base_uri ENV['SUPABASE_URL']

  def self.sign_up(email, password, phone, name)
    response = post("/auth/v1/signup",
      headers: {
        "apikey" => ENV['SUPABASE_KEY'],
        "Content-Type" => "application/json"
      },
      body: {
        email: email,
        password: password,
        options: {
          emailRedirectTo: ENV['SUPABASE_EMAIL_REDIRECT_URL'] + "/login"
        },
        data: {
          name: name,
          phone: phone
        }
      }.to_json
    )

   response.parsed_response
  end

  def self.sign_in(email, password)
    response = post("/auth/v1/token?grant_type=password",
      headers: {
        "apikey" => ENV['SUPABASE_KEY'],
        "Content-Type" => "application/json"
      },
      body: {
        email: email,
        password: password
      }.to_json
    )

    response.parsed_response
  end

  def self.sign_in_with_google(redirect_url)
    google_auth_url = "#{ENV['SUPABASE_URL']}/auth/v1/authorize?provider=google&redirect_to=#{redirect_url}"
    { "url" => google_auth_url }
  end

  def self.get_user_info(access_token)
    response = get("/auth/v1/user",
      headers: {
        "apikey" => ENV['SUPABASE_KEY'],
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json"
      }
    )

    response.parsed_response
  end

end