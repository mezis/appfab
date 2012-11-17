# encoding: UTF-8
class Account < ActiveRecord::Base
  attr_accessible :name, :auto_adopt, :domain

  has_many :users, :dependent => :destroy
  has_many :ideas, :through => :users

  validates_presence_of :name
  validates_presence_of :domain, if: :auto_adopt

  store :settings, accessors: [ :categories ]

  default_values auto_adopt:false, categories: lambda { Set.new }


  def categories_with_default
    return categories_without_default if categories_without_default.kind_of?(Set)
    self.categories = Set.new
  end
  alias_method_chain :categories, :default

end
