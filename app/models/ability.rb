# encoding: UTF-8
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Idea permissions
    draft_or_submitted = [:draft, :submitted].map { |sym| Idea.state_value(sym) }
    can :read, Idea, author: { account_id: user.account_id }
    if user.plays?(:submitter)
      can :create,  Idea, author: { account_id: user.account_id }
      can :update,  Idea, author: { account_id: user.account_id }, state: draft_or_submitted
      can :destroy, Idea, author_id: user.id, state: draft_or_submitted
    end

    can :move, Idea do |idea|
      user == idea.author || user == idea.product_manager || user.plays?(:account_owner)
    end

    # Comment
    can    :create, Comment, idea: { author: { account_id: user.account_id } }
    can    :read,   Comment, author: { account_id: user.account_id }
    can    :vote,   Comment
    cannot :vote,   Comment, author_id: user.id
    can    [:update, :destroy], Comment do |r|
      r.author_id == user.id && r.recently_created?
    end

    # Attachment
    can :read, Attachment
    [:create, :update, :destroy].each do |action|
      can action, Attachment do |r|
        can?(:update, r.owner)
      end
    end

    # Sizing / Vetting
    if user.plays?(:product_manager, :architect)
      can :size,     Idea
      can :create,   Vetting
      can :destroy,  Vetting do |r|
        r.user_id == user.id && r.recently_created?
      end
    end

    # Vote
    can :create,  Vote
    can :destroy, Vote do |r|
      r.user_id == user.id && r.recently_created?
    end

    # Idea lifecycle
    if user.plays?(:product_manager)
      can :pick, Idea
    end
    can :design,    Idea, product_manager_id: user.id
    can :implement, Idea, product_manager_id: user.id
    can :deliver,   Idea, product_manager_id: user.id


    if user.plays?(:benevolent_dictator)
      can :approve,  Idea
      can :sign_off, Idea
      can :veto,     Idea
    end

    # User
    can :read,   User, account_id: user.account_id
    can :update, User, id: user.id

    if user.plays?(:account_owner)
      can [:update, :update_voting_power, :destroy], User, account_id: user.account_id
    end

    # User role
    can :read, User::Role
    if user.plays?(:account_owner)
      can [:create, :destroy], User::Role
    end

    # Notification
    can :read,   Notification::Base, recipient_id: user.id
    can :update, Notification::Base, recipient_id: user.id

    # Account
    can :create, Account
    can :read, Account, id: user.account_id
    if user.plays?(:account_owner)
      can [:update, :destroy], Account, id: user.account_id
    end
  end
end
