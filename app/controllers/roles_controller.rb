class RolesController < ApplicationController
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token
  before_action :set_role, only: [:show, :edit, :update, :assign, :remove]

  def index
    roles = Role.all
    render json: roles
  end

  def show
    render json: { role: @role, permissions: @role.permissions }
  end

  def create
    role = Role.new(role_params)
    if role.save
      assign_permissions(role, params[:permission_ids], params[:permissions])
      render json: { message: "Role created successfully", role: role, permissions: role.permissions }, status: :created
    else
      render json: { error: role.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    render json: { role: @role, permissions: @role.permissions }
  end

  def update
    if @role.update(role_params)
      assign_permissions(@role, params[:permission_ids], params[:permissions])
      render json: { message: "Role updated successfully", role: @role, permissions: @role.permissions }
    else
      render json: { error: @role.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def assign
    user = User.find(params[:user_id])
    user.roles << @role unless user.roles.include?(@role)
    render json: { message: "Role assigned successfully", roles: user.roles }
  end

  def remove
    user = User.find(params[:user_id])
    user.roles.delete(@role)
    render json: { message: "Role removed successfully", roles: user.roles }
  end

  private

  def set_role
    @role = Role.find(params[:id] || params[:role_id])
  end

  def role_params
    params.require(:role).permit(:name, :description)
  end

  def assign_permissions(role, permission_ids = nil, permission_objects = nil)
    permissions = []

    permissions += Permission.where(id: permission_ids) if permission_ids.present?

    if permission_objects.present?
      permission_objects.each do |perm|
        next unless perm.is_a?(Hash) && perm[:name].present?
        permissions << Permission.find_or_create_by(name: perm[:name])
      end
    end

    role.permissions = permissions.uniq
  end
end