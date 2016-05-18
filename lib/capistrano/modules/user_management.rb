module UserManagement
  def whoami
    capture(:whoami)
  end

  def am_i?(user_name)
    whoami == user_name
  end
end
