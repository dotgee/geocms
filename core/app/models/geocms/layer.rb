require "curb"
module Geocms
  class Layer < ActiveRecord::Base
    extend FriendlyId
    include ::PgSearch

    belongs_to :data_source
    has_many :contexts_layers,  -> { uniq.order(:position) },  dependent: :destroy
    has_many :contexts,         through: :contexts_layers
    has_many :dimensions#,       order: 'dimensions.value ASC'
    has_many :bounding_boxes,   dependent: :destroy

    has_many :categorizations
    has_many :categories, through: :categorizations

    accepts_nested_attributes_for :bounding_boxes
    delegate :wms, :wms_version, :not_internal, :ogc, :name, to: :data_source, prefix: true

    friendly_id :title, use: [:slugged, :finders]
    mount_uploader :thumbnail, Geocms::LayerUploader
    validates_presence_of :data_source_id, :name, :title

    default_scope -> { order(:title) }
    pg_search_scope :search, against: [:name, :title]

    # Finds the relevant bbox among all the bboxes stored
    # First check if there is a bounding box in EPSG:3857 (leaflet default)
    def boundingbox
      bbox = bounding_boxes.leafletable.any? ? bounding_boxes.leafletable.first : []
      bbox.to_bbox
    end

    def thumb_url(width = 64, height = 64, native_srs)
      bbox = self.bounding_boxes.first
      box = bbox.to_bbox if bbox
      return '/images/defaultmap.png' if box.nil?
      ROGC::WMSClient.get_map(data_source.wms, name, box, width, height, bbox.crs)
    end

    # TODO: Scary code
    def do_thumbnail(force=false)
      if force || self.thumbnail.url.nil?
        tempfile = Tempfile.new([ self.id.to_s, '.png' ])
        tempfile.binmode
        begin
         tempfile << Curl.get(self.thumb_url(64, 64, self.crs)).body_str
         tempfile.rewind
         self.thumbnail = tempfile
         # self.remote_thumbnail_url = self.thumb_url(64, 64, self.crs)
         self.save!
        rescue => e
          logger.error e.message
        ensure
         tempfile.close
         tempfile.unlink
        end
      end
    end

  end
end