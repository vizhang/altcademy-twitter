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
        render render json: {success: false}, status: 404
      end
    else
      render json: {success: false}, status: 404
    end
  end

  def destroy

  end

  def index
    @tweets = Tweet.all
    if @tweets
      render 'tweets/index.jbuilder'
    else
      render json: {success: false}, status: 404
    end
  end


  def index_by_user
    user = User.find_by(user_id: params[:id])
    if user
      render json: {username: user.username}

    else
      render json: {success: false}, status: :bad_request
    end
  end

  private

  def tweet_params
    p = params.require(:tweet).permit(:message)
    return p
  end

end
