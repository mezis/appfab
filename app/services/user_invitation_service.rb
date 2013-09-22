class UserInvitationService

  def initialize(inviter:nil, login:nil)
    raise ArgumentError if inviter.nil? || login.nil?

    @inviter = inviter
    @login   = login
  end

  def run
    login = Login.where(email:@login.email).first

    if login.nil?
      login = Login.create!(
        email:      @login.email,
        first_name: @login.first_name,
        last_name:  @login.last_name,
        password:   SecureRandom.hex)
    end

    return false if login.accounts.include?(@inviter.account)

    new_user = login.users.create!(account: @inviter.account)
    User::InvitationMailer.invitation(inviter:@inviter, user:new_user).deliver
    return true
  end
end
