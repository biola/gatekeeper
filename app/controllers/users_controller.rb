class UsersController < ApplicationController
  def show
    load_user

    if @user.confirmed?
      redirect_to edit_user_path(@user)
    end
  end

  def new
    @user = NonBiolan.new

    session[:return_url] = params[:return] if params[:return].present?
  end

  def create
    if @user = NonBiolan.create(user_params)
      UserMailer.email_confirmation(@user).deliver_now
      log_in @user
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    load_user
  end

  def update
    load_user

    # TODO
  end

  def confirm
    load_user

    if @user.confirmed?
      flash.now[:alert] = 'Your email address has already been confirmed.'
    elsif @user.confirmation_key == params[:key]
      @user.update! confirmed: true
      log_in @user
      flash.now[:notice] = "Your email address #{@user.email} has been confirmed."

      if session[:return_url].present?
        @return_url = session.delete(:return_url)
      end
    else
      flash.now[:alert] = 'Could not confirm your email address. Invalid confirmation key.'
    end
  end

  def destroy
    # TODO
  end

  private

  def load_user
    @user ||= NonBiolan.find(params[:id])
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def user_params
    params.require(:non_biolan).permit :first_name, :last_name, :email, :password
  end
end
