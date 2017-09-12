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
    accepts_nested_attributes_for :dimensions

    delegate :wms, :wms_version, :not_internal, :ogc, :name, to: :data_source, prefix: true

    friendly_id :title, use: [:slugged, :finders]
    mount_uploader :thumbnail, Geocms::LayerUploader
    validates_presence_of :data_source_id, :name, :title

    after_commit :get_thumbnail, on: :create

    default_scope -> { order(:title) }
    pg_search_scope :search, against: [:name, :title]

    # Finds the relevant bbox among all the bboxes stored
    # First check if there is a bounding box in EPSG:3857 (leaflet default)
    def boundingbox
      bbox = bounding_boxes.leafletable.first
      bbox.nil? ? [] : bbox.to_bbox
    end

    def bboxCrs
      bbox = bounding_boxes.leafletable.first
      return bbox.crs
    end
    
    def self.bulk_import(layers)
      logger.info "simple test"
      ActiveRecord::Base.transaction do
        layers.each {|l| self.create!(l)}
      end
    end

    private

    def get_thumbnail 
      box = bounding_boxes.leafletable.first
      LayerThumbnailWorker.perform_async(id, data_source_wms, box.crs, box.to_bbox) unless box.nil?
    end
  end
end
