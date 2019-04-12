class TweetsController < ApplicationController
  def create
    #get session from cookie, and find user from that
    token = cookies.signed['twitter_session_token']
    session = Session.find_by(token: token)

    #compare session token with user's session token
    if session
      user = session.user
      @tweet = user.tweets.new(tweet_params)
      if @tweet.save
        render 'tweets/create.jbuilder'
      else
        render json: {success: false}, status: 404
      end
    else
      render json: {success: false}, status: 404
    end
  end

  def destroy
    token = cookies.signed['twitter_session_token']
    session = Session.find_by(token: token)

    #compare session token with user's session token
    if session
      user = session.user
      tweet = user.tweets.find_by(id: params[:id])
      if tweet.destroy
        render json: {success: true}, status: :ok
      else
        render json: {success: false}, status: :internal_server_error
      end
    else
      render json: {success: false}, status: :unauthorized
    end
  end

  def index
    @tweets = Tweet.all.order(created_at: :desc)
    if @tweets
      render 'tweets/index.jbuilder'
    else
      render json: {success: false}, status: :internal_server_error
    end
  end


  def index_by_user
    user = User.find_by(username: params[:username])
    if user
      @tweets = user.tweets
      render 'tweets/index.jbuilder'

    else
      render json: {success: false}, status: :not_found
    end
  end

  private

  def tweet_params
    p = params.require(:tweet).permit(:message)
    return p
  end

end
