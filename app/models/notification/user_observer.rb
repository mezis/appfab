class Notification::UserObserver < ActiveRecord::Observer
  observe :user

  def after_save(record)
    return unless record.account && record.account_id_changed?
    record.account.users.each do |account_user|
      Notification::NewUser.create!(recipient:account_user, subject:record)
    end
  end

end
