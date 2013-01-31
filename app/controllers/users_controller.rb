class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    # 'unless' condition used for Exercise 9.6.6 to prevent signed-in users
    # from accessing the the signup (new) page
    # result: redirect to home page
    unless signed_in?
      @user = User.new
    else
      redirect_to(root_path)
    end
  end
  
  def create
    # 'unless' condition used for Exercise 9.6.6 to prevent signed-in users
    # from accessing the the signup (new) page
    # result: redirect to home page
    unless signed_in?
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render 'new'
      end
    else
      redirect_to(root_path)
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end  

  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      #Handle a successfule update
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end    
  end

  def destroy
    if User.find(params[:id]).admin == false
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    else
      redirect_to(root_path)
    end
  end


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
