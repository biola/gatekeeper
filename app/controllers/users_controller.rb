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
    @user.user_agent = request.user_agent
    @user.ip_address = request.ip

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

    if user_params[:password].present? && !@user.authenticate(params[:current_password])
      flash.now.alert = 'Invalid current password'
      render :edit
    elsif @user.update user_params
      redirect_to edit_user_path, notice: 'Changes saved'
    else
      render :edit
    end
  end

  def delete
    load_user

    authorize @user
  end

  def destroy
    load_user

    authorize @user

    @user.backup_and_destroy!
    logout!
    redirect_to root_url, notice: 'Account deleted'
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
