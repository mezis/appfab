# encoding: UTF-8
class Notification::IdeaObserver < ActiveRecord::Observer
  observe :idea

  def after_create(record)
    return unless record.account # happens in tests
    record.account.users.playing(:product_manager, :architect).each do |user|
      Notification::NewIdea.create! subject:record, recipient:user
    end
  end
end
