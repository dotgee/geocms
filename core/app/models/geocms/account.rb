module Geocms
  class Account < ActiveRecord::Base
    include Geocms::Preferences

    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships
    accepts_nested_attributes_for :users

    has_many :categories, dependent: :destroy
    has_many :layers, -> { uniq }, through: :categories
    has_many :contexts, dependent: :destroy

    preference :longitude , -1.676239
    preference :latitude  , 48.118434
    preference :zoom      , 4
    preference :crs       , "EPSG:3857"
    preference :host      , "localhost"
    preference :prefix_uri, ""
    preference :geovisu_url, "/geovisu"
    preference :screenshot_url, ""


    CRS = ["EPSG:4326", "EPSG:2154", "WGS:84"]

    mount_uploader :logo, Geocms::LogoUploader

    validates_presence_of :name
    validates_uniqueness_of :name
    validates :subdomain, presence: true, uniqueness: true, subdomain: { :reserved => %w(www test) }

    def prefs
      preferences.map { |k| {"#{k.name}" => k.value} }.reduce({}, :merge)
    end

  end
end