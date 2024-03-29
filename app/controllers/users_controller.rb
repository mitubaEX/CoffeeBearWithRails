class UsersController < ApplicationController
    # before_action :logged_in_user, only: [:edit, :update]
    before_action :logged_in_user, only: [:edit, :update, :index, :show, :destroy]
    before_action :correct_user,   only: [:edit, :update]
    before_action :admin_user,     only: :destroy


    def new
        @user = User.new
    end

    def index
        @users = User.paginate(page: params[:page])
    end

    def create
        @user = User.new(user_params)    # 実装は終わっていないことに注意!
        if @user.save
            log_in @user
            flash[:success] = "Welcome to the Sample App!"
            redirect_to @user
        else
            render 'new'
        end
    end

    def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            # 更新に成功した場合を扱う。
            flash[:success] = "Profile updated"
            redirect_to @user
        else
            render 'edit'
        end
    end

    def user_params
        params.require(:user).permit(:username, :password,
                                     :password_confirmation)
    end

    def edit
        @user = User.find(params[:id])
    end

    def show
        @user = User.find(params[:id])
    end

    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to users_url
    end

    private

    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
        unless logged_in?
            flash[:danger] = "Please log in."
            redirect_to login_url
        end
    end

    # 正しいユーザーかどうか確認
    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
