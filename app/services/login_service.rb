# Takes an auth hash and returns a matching Login.
# May also create a User when an account has domain-based auto adoption.
class LoginService
  def initialize(auth_hash)
    @auth_hash = auth_hash.dup
    @login = nil
  end

  def run
    _find_or_build_login
    _update_login!
    _adopt_account!
    @login
  end

  private

  EmailDomainRE = /@(?<domain>.*)$/

  def _find_or_build_login
    Rails.logger.debug("Auth hash: #{@auth_hash.inspect}")

    if @auth_hash[:provider] == 'developer'
      @login = Login.where(email: @auth_hash[:info][:email]).first
      return if @login.present?
    end

    @login = Login.where(uid: @auth_hash[:uid], provider: @auth_hash[:provider]).first
    return if @login.present?

    @login = Login.new.tap do |login|
      login.email    = @auth_hash[:info][:email]
      login.password = SecureRandom.base64
    end
  end


  def _update_login!
    if @auth_hash[:info][:first_name]
      @login.first_name = @auth_hash[:info][:first_name]
      @login.last_name  = @auth_hash[:info][:last_name]
    elsif @auth_hash[:info][:name] =~ /(.*?)\s+(.*)/
      @login.first_name = $1.andand.strip
      @login.last_name  = $2.andand.strip
    else
      @login.first_name = @auth_hash[:info][:name].strip
    end

    @login.provider = @auth_hash[:provider]
    @login.uid      = @auth_hash[:uid]
    @login.auth_provider_data[@login.provider] ||= @auth_hash.to_hash
    @login.remember_me = true
    @login.save!
  end


  def _email_domain(email)
    EmailDomainRE.match(email).andand[:domain]
  end


  def _adopt_account!
    return unless domain = _email_domain(@login.email)
    return if @login.users.any?

    account = Account.where(domain:domain, auto_adopt:true).first
    return if account.nil?
    @login.users.create! account:account
  end
end
