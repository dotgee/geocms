module Geocms::Preferences
  extend ActiveSupport::Concern

  included do
    has_many :preferences
    @@preferences = {}
  end

  module ClassMethods
    def preference(name, default)
      preferences = self.class_variable_get(:'@@preferences')
      preferences[name] = default
      self.class_variable_set(:'@@preferences', preferences)
    end

    def prefs
      self.class_variable_get(:'@@preferences')
    end
  end

  def read_preference(name)
    if p = self.preferences.where(:name => name).first
      return p
    end
    return self.preferences.new(:name => name, :value => @@preferences[name]) if @@preferences.has_key?(name)
    nil
  end

  def write_preference(name, value)
    p = self.preferences.where(name: name).first_or_create
    p.update_attribute(:value, value)
  end

  def method_missing(method, *args)
    if @@preferences.keys.any?{|k| method =~ /#{k}/}
      if method =~ /=/
        self.write_preference(method.gsub('=', ''), *args)
      else
        self.read_preference(method)
      end
    else
      super
    end
  end
end
