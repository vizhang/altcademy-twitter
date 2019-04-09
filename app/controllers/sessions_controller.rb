class SessionsController < ApplicationController
  # :tweet_session_token = 'twitter_session_token'

  def create
    user = User.find_by(username: params[:user][:username])

    encryptedPwd = BCrypt::Password.new(user.password)
    if user && (user.password == encryptedPwd)
      session = user.sessions.create
      cookies.permanent.signed['twitter_session_token'] = {
        value: session.token,
        httponly: true
      }
      render json: {success: true}, status: 200
    else
      render json: {success: false}, status: 404
    end
  end

  def authenticated
    #get session token from cookie
    token = cookies.signed['twitter_session_token']
    # puts "token: " + token.inspect
    session = Session.find_by(token: token)
    # puts "session: " + session.inspect

    #compare session token with user's session token
    if session
      user = session.user
      render json: {authenticated: true, username: user.username}, status: 200
    else
      render json: {authenticated: false}, status: 404
    end
  end

  def destroy
    token = cookies.signed['twitter_session_token']
    session = Session.find_by(token: token)
    #destroy session if it can be found by token
    if session and session.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  private

  def user_params
    p = params.require(:user).permit(:username, :password,)
    puts "SESSION- user_params are: " + p.inspect
    return p
  end
end
