class UsersController < ApplicationController
  before_action :authorize, only: [:show, :update, :destroy], dependent: :destroy  # :delete khong can cung dc;  #dependent: :destroy  <dùng để huỷ luôn tasks phụ thuộc khi users bị huỷ>
  before_action :set_user, only: [:show, :update, :destroy] # :delete khong can cung dc, ca

  # LIST: cái này có thể dùng cho admin về sau, pj này ko cần, để đây thôi =))
  def index
    @users = User.all
    render json: { users: @users }
  end

  # SHOW INFO (GET /users/1)
  def show
    render json: @user
  end

  # UPDATE (PATCH/PUT /users/1)
  def update
    # if @user.update(user_params_u)
    #   render json: @user, , status: 200
    # else
    #   render json: @user.errors, status: 422
    # end

    # check password đã nếu confirm mới cho update nhé
    if @user && @user.authenticate(user_params_u[:password])
      if @user.update(nickname: params['user']['nickname'], password: params['user']['password_n'])
        render json: @user, status: 200
        # binding.pry
      else
        render json: @user.errors, status: 422
      end
    else
      render json: { error: 'Invalid password!!' }, status: 422 # :unprocessable_entity
    end
  end

  # SIGNUP/ REGISTER
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: 200
    else
      render json: @user.errors, status: 422
    end
  end

  # LOGIN
  def login
    @user = if User.find_by(nickname: user_params[:nickname]) != nil
              User.find_by(nickname: user_params[:nickname])
            else
              User.find_by(email: user_params[:email])
            end

    if @user && @user.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: 200
    else
      render json: { error: 'Invalid!!' }, status: 422 # :unprocessable_entity
    end
  end

  # DELETE   #pj này ko dùng đến delete, để test thôi
  def destroy
    if @user.destroy
      render json: { message: 'Deleted user successfully.' }, status: 200
    else
      render json: @user.errors, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :password, :email)
  end

  def user_params_u
    params.require(:user).permit(:nickname, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
