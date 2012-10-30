class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email_address, :role, :karma, :account_id
end
