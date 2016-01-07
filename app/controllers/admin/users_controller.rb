class Admin::UsersController < Admin::ApplicationController
  def index
    @users = policy_scope(NonBiolan).asc(:last_name, :first_name).page(params[:page])
  end

  def show
    @user = NonBiolan.find(params[:id])

    authorize @user

    if @user.unconfirmed?
      flash.now.notice = "This user has not yet confirmed their email"
    end

    if @user.deleted?
      flash.now.alert = "This user has been deleted"
    end
  end

  def edit
    @user = NonBiolan.find(params[:id])

    authorize @user
  end

  def update
    @user = NonBiolan.find(params[:id])

    authorize @user

    if @user.update user_params
      redirect_to admin_user_path(@user), notice: 'User updated'
    else
      render :edit
    end
  end

  def destroy
    @user = NonBiolan.find(params[:id])

    authorize @user

    msg = unless @user.update deleted: true
      'Unable to delete user'
    end

    redirect_to admin_user_path(@user), alert: msg
  end

  private

  def user_params
    params.require(:non_biolan).permit :first_name, :last_name, :email, :password, :password_confirmation, :confirmed, :deleted
  end

  def policy(user)
    Admin::UserPolicy.new(current_user, user)
  end

  def pundit_policy_scope(scope)
    Admin::UserPolicy::Scope.new(current_user, scope).resolve
  end
end
