module ApplicationHelper
  def routine_path_for(user)
    return root_path unless user

    if user.parent?
      parent_role_root_path
    else
      child_role_routines_path
    end
  end
end
