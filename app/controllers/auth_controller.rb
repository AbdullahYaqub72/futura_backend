class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:register, :login, :google_login] # 👈 Skip CSRF check for API calls

  def register
    email = params[:email]
    password = params[:password]
    phone = params[:phone]
    name = params[:name]
    business_params = params.require(:business_attributes).permit(:name, :description, :phone, :email) if params[:business_attributes].present?  
    
    if User.exists?(email: email)
      render json: { error: "A user with this email already exists" }, status: :unprocessable_entity
      return
    end
      
    response = SupabaseService.sign_up(email, password, phone, name)
  
    if response["error"] || (response["code"].present? && (response["code"] != 200 && response["code"] != 201))
      render json: { error: response["msg"] || response["error"] }, status: :unprocessable_entity
      return
    end
  
    supabase_user = response["user"] || response["data"] || response
  
    User.transaction do
      user = User.new(name: name, email: email, phone: phone, password: password, supabase_id: supabase_user["id"])
      if user.save
        if business_params.present?
          business = Business.create(business_params)
          user.update(business_id: business.id) if business.persisted?
        elsif current_user&.business_id.present?
          user.update(business_id: current_user&.business_id)
        end
        render json: { message: "User registered successfully", user: user }, status: :created
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def login
    email = params[:email]
    password = params[:password]

    response = SupabaseService.sign_in(email, password)
    if response["error"] || response["code"] == 400 || (response["code"].present? && response["code"] != 200)
      error_message = response["msg"] || "Invalid credentials"
      render json: { error: error_message }, status: :unauthorized
    else
      render json: { message: "Login successful", token: response["access_token"], user: response["user"] }, status: :ok
    end
  end

  def google_login
    redirect_url = params[:redirect_url] || "http://localhost:3000/auth/callback"
    google_url = SupabaseService.sign_in_with_google(redirect_url)

    redirect_to google_url["url"], allow_other_host: true
  end

  def google_callback
    access_token = params[:access_token]  # Supabase sends this after successful login

    if access_token
      user_info = SupabaseService.get_user_info(access_token)

      if user_info["error"]
        render json: { error: user_info["error"]["message"] }, status: :unprocessable_entity
      else
        # Store session or JWT token if needed
        render json: { message: "Login successful", user: user_info }, status: :ok
      end
    else
      render json: { error: "No access token provided" }, status: :unauthorized
    end
  end

end