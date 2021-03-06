class UniqueRoles < ActiveRecord::Migration
  class UserProjectRole < ActiveRecord::Base
  end

  def up
    # delete the lowest permission duplicate roles
    UserProjectRole.all.group_by(&:user_id).each do |_user, roles|
      roles.sort_by(&:role_id)[0..-2].each(&:destroy)
    end

    add_index :user_project_roles, [:user_id, :project_id], unique: true
    remove_index :user_project_roles, :user_id
  end

  def down
    add_index :user_project_roles, :user_id
    remove_index :user_project_roles, [:user_id, :project_id]
  end
end
