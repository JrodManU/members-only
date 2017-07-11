class PostsController < ApplicationController
  before_action :valid_user, only: [:new, :create]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "Post created."
      redirect_to root_url
    else
      flash[:danger] = "Please try again."
      render 'new'
    end
  end

  private
    def post_params
      params[:post][:user_id] = current_user.id
      params.require(:post).permit(:title, :body, :user_id)
    end

    def valid_user
      unless current_user
        flash[:danger] = "You must be a member to do that."
        redirect_to root_url
      end
    end
end
