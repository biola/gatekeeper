class Admin::UsersController < Admin::ApplicationController
  def index
    users = policy_scope(User).all

    if params[:q]
      begin
        regex = Regexp.new(params[:q].gsub(/\s/, '.*'), Regexp::IGNORECASE)
        ids = User.collection.aggregate([
          {:$project =>
            {
              uuid: '$uuid',
              email: '$email',
              full_name: {:$concat => ['$first_name', ' ', '$last_name']}
            }
          },
          {:$match => {:$or => [
            {uuid: regex},
            {email: regex},
            {full_name: regex}
          ]}}
        ]).map { |p| p[:_id] }

        users = policy_scope(User).where(:id.in => ids)
      rescue RegexpError
        users = User.none
      end
    end

    @users = users.asc(:last_name, :first_name).page(params[:page])
  end

  def show
    @user = NonBiolan.find(params[:id])

    authorize @user

    if @user.unconfirmed?
      flash.now.notice = "This user has not yet confirmed their email"
    end
  end

  def edit
    @user = NonBiolan.find(params[:id])

    authorize @user
  end

  def update
    @user = NonBiolan.find(params[:id])

    authorize @user

    user_prms = user_params
    if params[:trogdir_id].present?
      uuid = TrogdirPerson.new(params[:trogdir_id], params[:trogdir_id_type]).uuid
      user_prms.merge! trogdir_uuid: uuid if uuid.present?
    end

    if @user.update user_prms
      redirect_to admin_user_path(@user), notice: 'User updated'
    else
      render :edit
    end
  end

  def destroy
    @user = NonBiolan.find(params[:id])

    authorize @user

    deleted_user = @user.backup_and_destroy!

    redirect_to admin_deleted_user_path(deleted_user), notice: 'User deleted'
  end

  protected

  def search_path
    admin_users_path
  end

  private

  def user_params
    params.require(:non_biolan).permit :first_name, :last_name, :username, :email, :password, :password_confirmation, :confirmed_at, :trogdir_uuid
  end

  def policy(user)
    Admin::UserPolicy.new(current_user, user)
  end

  def pundit_policy_scope(scope)
    Admin::UserPolicy::Scope.new(current_user, scope).resolve
  end
end
