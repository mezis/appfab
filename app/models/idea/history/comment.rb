class Idea::History::Comment < Idea::History::Base
  validate :subject_must_be_comment

  def subject_must_be_comment
    return if subject.kind_of?(Comment)
    errors.add :subject, _('Subject must be a comment')
  end

  module IsSubject
    extend ActiveSupport::Concern
    
    included do
      has_one :idea_history, dependent: :destroy, class_name:'Idea::History::Comment', as: :subject, inverse_of: :subject
      after_create do |record|
        record.create_idea_history!(idea:record.idea)
      end
    end
  end
end
