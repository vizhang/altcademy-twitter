class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user and @user.save
      render 'users/create.jbuilder'

    else
      render json: {success: false}, status: :bad_request
    end
  end

  private

  def user_params
    p = params.require(:user).permit(:username, :email, :password,)
    puts "user_params are: " + p.inspect
    return p
  end

end
