class Message::Marketing < ActiveRecord::Base
  self.table_name = 'messages_marketing'

  include Notification::Base::CanBeSubject

  # attr_accessible :link, :summary
  store :payload, accessors: [ :summary, :body ]

  default_values summary:proc { Hash.new }
  validates_presence_of :summary
  validate :summary_all_locales

  # +recipients+ can be an Account, a User, or :all
  # idempotent -- will not notify a user twice about the same message
  def notify!(recipients)
    scope = case recipients
      when :all    then User
      when User    then User.where(id: recipients.id)
      when Account then recipients.users
      else raise ArgumentError
    end

    existing_recipient_ids = self.notified_users.pluck(:id)
    scope = scope.excluding_ids(existing_recipient_ids) if existing_recipient_ids.any?
    
    transaction do
      scope.find_each do |user|
        Notification::MarketingMessage.create!(recipient:user, subject:self)
      end
    end
  end

  private

  def summary_all_locales
    if summary.keys != FastGettext.available_locales
      errors.add :summary, _('Summary must be provided in all locales')
    end
    if summary.values.any?(&:blank?)
      errors.add :summary, _('Summary cannot be empty in any locale')
    end
  end
end
