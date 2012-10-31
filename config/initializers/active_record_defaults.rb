module SocialP ; end
module SocialP::ActiveRecordDefaults
  def defaults(options = {})
    self.before_validation do |record|
      options.each do |key, value|
        next unless self.send(key).nil?
        self.send("#{key}=".to_sym, value)
      end
    end
  end
end

ActiveRecord::Base.extend(SocialP::ActiveRecordDefaults)
