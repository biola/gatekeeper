class UsersController < ApplicationController
  include Session

  def show
    load_user

    authorize @user

    if @user.confirmed?
      redirect_to edit_user_path
    end
  end

  def new
    redirect_to(user_path) if current_user.present?

    @user = NonBiolan.new

    authorize @user

    session[:return_url] = params[:return] if params[:return].present?
  end

  def create
    @user = NonBiolan.new(user_params)

    authorize @user

    if @user.save
      UserMailer.email_confirmation(@user).deliver_now
      login! @user
      redirect_to user_path
    else
      render :new
    end
  end

  def edit
    load_user
    authorize @user
  end

  def update
    load_user

    authorize @user

    if @user.update user_params
      redirect_to edit_user_path, notice: 'Changes saved'
    else
      render :edit
    end
  end

  def confirm
    @user = User.where(confirmation_key: params[:key]).first

    authorize @user

    if @user.nil?
      flash.now.alert = 'Could not confirm your email address. Invalid confirmation key.'
    elsif @user.confirmed?
      flash.now.alert = 'Your email address has already been confirmed.'
    else
      @user.update! confirmed: true
      login! @user
      flash.now.notice = "Your email address #{@user.email} has been confirmed."

      if session[:return_url].present?
        @return_url = session.delete(:return_url)
      end
    end
  end

  def destroy
    load_user

    authorize @user

    if @user.update deleted: true
      logout!
      redirect_to root_url, notice: 'Account deleted'
    else
      redirect_to edit_user_path, alert: 'Unable to delete account'
    end
  end

  private

  def load_user
    @user ||= current_user
  end

  def user_params
    params.require(:non_biolan).permit :first_name, :last_name, :email, :password, :password_confirmation
  end

  def policy(user)
    UserPolicy.new(current_user, user)
  end
end
