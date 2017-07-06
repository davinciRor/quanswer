class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user

  def facebook
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  end

  def twitter
    if @user.email_verified?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      redirect_to finish_signup_path(@user)
    end
  end

  private

  def set_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end
end