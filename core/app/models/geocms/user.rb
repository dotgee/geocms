require 'digest/md5'

module Geocms
  class User < ActiveRecord::Base
    rolify
    authenticates_with_sorcery!

    has_many :memberships
    has_many :accounts, through: :memberships
    #acts_as_tenant(:account)
    #after_create :define_role
    before_save :create_md5

    def self.network_json
      User.all.map { |u| {value: u.username, name: u.full_name, tokens: [u.first_name, u.last_name, u.username], profileImageUrl: "http://www.gravatar.com/avatar/#{u.email_md5}?s=20&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"} }
    end

    def full_name
      [first_name, last_name].reject(&:blank?).join(" ")
    end

    private
    def define_role
      if account.users.empty?
        self.add_role :admin, account
      end
    end

    def create_md5
      if self.email_md5.nil? || email_changed?
        self.email_md5 = Digest::MD5.hexdigest(email.downcase)
      end
    end

    attr_accessible :email, :password, :password_confirmation, :username, :account, :account_id, :first_name, :last_name, :email_md5

    validates_confirmation_of :password
    validates_presence_of :password, on: :create

    validates_presence_of :username
    validates_uniqueness_of :username
    validates_presence_of :email
    validates_uniqueness_of :email

  end
end