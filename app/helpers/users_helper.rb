module UsersHelper

  def is_owner_or_admin?(current_user)
    @owner == current_user
  end

end
