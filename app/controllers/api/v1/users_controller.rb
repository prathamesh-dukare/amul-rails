class Api::V1::UsersController < ApplicationController
  # GET /api/v1/users
  def index
    users = User.all
    render json: users
  end

  # GET /api/v1/users/:id
  def show
    user = User.find(params[:id])
    render json: user
  end

  # POST /api/v1/users
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/users/:id
  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:id
  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :first_name, :last_name, :bio, :avatar_url)
  end
end


