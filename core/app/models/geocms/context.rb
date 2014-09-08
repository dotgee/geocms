module Geocms
  class Context < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: [:slugged, :finders]

    acts_as_tenant(:account)
    has_many :contexts_layers, -> { order(:position) }, :dependent => :destroy
    has_many :layers, :through => :contexts_layers

    belongs_to :folder, class_name: "Geocms::Folder"

    mount_uploader :preview, Geocms::ContextPictureUploader

    accepts_nested_attributes_for :contexts_layers, allow_destroy: true
    after_create :generate_uuid

    after_save :generate_preview
    after_save :set_default

    default_scope -> { order("created_at DESC") }

    def contexts_layers_attributes=(attrs)
      layers = []
      unless attrs.nil?
        attrs.each do |attr|
          layers << attr["layer_id"]
          context_layer = contexts_layers.detect{|cl| cl.layer_id == attr["layer_id"]}
          context_layer ||= contexts_layers.build
          context_layer.update_attributes!(attr)
        end
      end
      to_delete = (contexts_layers.map{ |l| l.layer_id } - layers)
      to_delete.each do |layer|
        context_layer = contexts_layers.detect{|cl| cl.layer_id == layer}
        context_layer.destroy
      end
    end

    def generate_uuid
      str = self.account.subdomain
      str.gsub!("-", "")
      self.uuid = str+"-"+(0...8).map{65.+(rand(26)).chr.downcase}.join
      save
    end

    def bbox
      [minx, miny, maxx, maxy].join(",")
    end

    private
      def generate_preview(url = nil, force = false)
        unless preview_changed?
          url ||= ENV["HOST_URL"]
          return true if url.nil?
          #return true if preview? and !force
          Geocms::ContextPreviewWorker.perform_async(self, url)
        end
      end

      def set_default
        Context.where('id != ?', id).update_all(by_default: false) if by_default
      end
  end
end
