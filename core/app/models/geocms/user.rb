require 'digest/md5'

module Geocms
  class User < ActiveRecord::Base
    rolify
    authenticates_with_sorcery!

    has_many :memberships
    has_many :accounts, through: :memberships

    has_many :folders, class_name: "Geocms::Folder"

    #acts_as_tenant(:account)
    #after_create :define_role
    before_save :create_md5
    after_create :set_folder

    def self.network_json
      User.all.map { |u| {value: u.username, name: u.full_name, tokens: [u.first_name, u.last_name, u.username], profileImageUrl: "http://www.gravatar.com/avatar/#{u.email_md5}?s=20&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"} }
    end

    def full_name
      [first_name, last_name].reject(&:blank?).join(" ")
    end

    def set_folder
      # begin
      #   uniq_name = uniq_name_generator()
      # end while (not Folder.where(name: uniq_name.to_s).first.blank?)
      self.folders.create(name: username, visibility: false)
    end

    private
    def define_role
      if account.users.empty?
        self.add_role :user, account
      end
    end

    def create_md5
      if self.email_md5.nil? || email_changed?
        self.email_md5 = Digest::MD5.hexdigest(email.downcase)
      end
    end

    def uniq_name_generator
      "#{self.username}_" + (Folder.where("name like ?", "#{self.username}_%").count+1).to_s
    end

  

    validates_confirmation_of :password
    validates_presence_of :password, on: :create

    validates_presence_of :username
    validates_uniqueness_of :username
    validates_presence_of :email
    validates_uniqueness_of :email
    validates_size_of :roles, :minimum => 1,:allow_nil => false,allow_blank: false
  end
end