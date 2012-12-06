# encoding: UTF-8
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new?

    # Idea permissions
    can [:create, :read], Idea, author: { account_id: user.account_id }
    can :update,          Idea, author_id: user.id, state: Idea.state_value(:submitted)
    can :destroy,         Idea, author_id: user.id, state: Idea.state_value(:submitted)

    # Comment
    can    [:create], Comment, idea: { author: { account_id: user.account_id } }
    can    [:read],   Comment, author: { account_id: user.account_id }
    can    [:vote],   Comment
    cannot [:vote],   Comment, author_id: user.id
    can    [:update, :destroy], Comment.recently_updated, author_id: user.id

    # Sizing / Vetting
    if user.plays?(:product_manager, :architect)
      can :size,     Idea
      can :create,   Vetting
      can :destroy,  Vetting.recently_created
    end

    # Vote on ideas
    can :create,  Vote, subject_type: 'Idea'
    can :destroy, Vote.recently_created

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
  end
end
