class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token

  # GET /users
  def index
    users = User.includes(:roles).where(business_id: current_user.business_id)
    data = users.map do |user|
      { id: user.id, name: user.name, email: user.email, phone: user.phone, created_at: user.created_at, business_id: user.business_id,
        roles: user.roles.map do |role| { id: role.id, name: role.name, description: role.description }
        end
      }
    end

    render json: data
  end

  # GET /users/:id
  def show
    render json: @user
  end

  # POST /users
  def create
    user = User.new(user_params)
  
    if current_user.present?
      # If current_user exists, assign their business to the new user
      user.business_id = current_user.business_id
    elsif params[:user][:business_attributes].present?
      # If there's no current_user (e.g., initial registration), create a business
      business_params = params[:user][:business_attributes].permit(:name, :description, :address, :phone, :email)
      business = Business.create(business_params)
      if business.persisted?
        user.business_id = business.id
      else
        render json: { error: business.errors.full_messages }, status: :unprocessable_entity and return
      end
    else
      render json: { error: "Business details required for user creation" }, status: :unprocessable_entity and return
    end
  
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end  

  # PATCH/PUT /users/:id
  def update
    if @user.business_id != current_user.business_id
      render json: { error: "Unauthorized access" }, status: :forbidden
    elsif @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    if @user.business_id != current_user.business_id
      render json: { error: "Unauthorized access" }, status: :forbidden
    else
      @user.destroy
      head :no_content
    end
  end

  # GET /users/by_supabase_id/:supabase_id
  def find_by_supabase_id
    user = User.find_by(supabase_id: params[:supabase_id], business_id: current_user&.business_id)
    if user
      render json: user.as_json(include: { roles: { only: [:id, :name, :description] } })
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  # GET /users/id_by_supabase_id/:supabase_id
  def find_id_by_supabase_id
    user = User.find_by(supabase_id: params[:supabase_id], business_id: current_user.business_id)
    if user
      render json: { user_id: user.id }
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  # GET /users/:id/roles_permissions
  def roles_permissions
    user = User.find_by(id: params[:id], business_id: current_user.business_id)
    if user
      render json: {
        roles: user.roles,
        permissions: user.roles.map(&:permissions).flatten.uniq
      }
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id], business_id: current_user.business_id)
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :phone, :revenue, :revenue_type, :password, :role, :supabase_id,
      business_attributes: [:name, :description, :address, :phone, :email]
    )
  end
end