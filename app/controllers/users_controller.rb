class UsersController < ApplicationController
  skip_authorization_check

  def finish_signup
    @user = User.find(params[:id])
    if request.patch? && params[:user]
      if @user.update(user_params)
        redirect_to root_path, notice: 'Your need confirm your email!'
      else
        @show_errors = true
      end
    end
  end

  private

  def user_params
    accessible = [ :name, :email ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end