class Admin::DeletedUsersController < Admin::ApplicationController
  def index
    deleted_users = policy_scope(DeletedUser).all

    if params[:q]
      begin
        regex = Regexp.new(params[:q].gsub(/\s/, '.*'), Regexp::IGNORECASE)
        ids = DeletedUser.collection.aggregate([
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

        deleted_users = policy_scope(DeletedUser).where(:id.in => ids)
      rescue RegexpError
        deleted_users = DeletedUser.none
      end
    end

    @deleted_users = deleted_users.asc(:last_name, :first_name).page(params[:page])
  end

  def show
    @deleted_user = DeletedUser.find(params[:id])

    authorize @deleted_user
  end

  protected

  def search_path
    admin_deleted_users_path
  end

  private

  def policy(user)
    Admin::DeletedUserPolicy.new(current_user, user)
  end

  def pundit_policy_scope(scope)
    Admin::DeletedUserPolicy::Scope.new(current_user, scope).resolve
  end
end
