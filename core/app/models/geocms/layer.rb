require "curb"
module Geocms
  class Layer < ActiveRecord::Base
    # include Geocms::Concerns::Searchable
    extend FriendlyId
    friendly_id :title, use: [:slugged, :finders]

    # ELASTICSEARCH MAPPING

    # define_mapping do
    #   indexes :id,           :index    => :not_analyzed
    #   indexes :title,        :analyzer => 'french_analyzer', :boost => 10
    #   indexes :name,         :analyzer => 'french_analyzer'
    #   indexes :description,  :analyzer => 'snowball'
    # end

    # RELATIONSHIPS

    belongs_to :data_source
    has_many :contexts_layers,  -> { uniq.order(:position) },  dependent: :destroy
    has_many :contexts,         through: :contexts_layers
    has_many :dimensions#,       order: 'dimensions.value ASC'
    has_many :bounding_boxes,   dependent: :destroy

    has_many :categorizations
    has_many :categories, through: :categorizations

    accepts_nested_attributes_for :bounding_boxes

    # SCOPES
    default_scope -> { order(:title) }
    scope :for_frontend, -> { select(
                              ["geocms_layers.name", "geocms_layers.title", "geocms_layers.id", "geocms_layers.description",
                                "geocms_layers.dimension", "geocms_layers.category_id", "data_sources.wms", "geocms_layers.metadata_url",
                                "geocms_dimensions.value" , "category_ids"
                              ]
                            )
                            .includes(:data_source).includes(:categories).includes(:dimensions)
  		                      .order("geocms_dimensions.value") }


    delegate :wms, :wms_version, :not_internal, :ogc, :name, to: :data_source, prefix: true

    # INSTANCE METHODS

    # Finds the relevant bbox among all the bboxes stored
    # First check if there is a bounding box in CRS:84 (leaflet default)
    # Otherwise fallback on another and convert it to CRS:84
    def boundingbox(tenant)
      bbox = bounding_boxes.leafletable.any?      ? bounding_boxes.leafletable.first      :
             bounding_boxes.current(tenant).any?  ? bounding_boxes.current(tenant).first  :
             bounding_boxes.any?                  ? bounding_boxes.first                  :
             nil
      bbox.for_leaflet unless bbox.nil?
    end

    def thumb_url(width = 64, height = 64, native_srs)
      bbox = self.bounding_boxes.first
      box = bbox.to_bbox if bbox
      return '/images/defaultmap.png' if box.nil?
      ROGC::WMSClient.get_map(data_source.wms, name, box, width, height, bbox.crs)
    end

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

    # ATTRIBUTES
    # store :bbox, accessors: [:minx, :maxx, :miny, :maxy]

    mount_uploader :thumbnail, Geocms::LayerUploader

    validates_presence_of :data_source_id, :name, :title

  end
end