module Geocms
  module PermittedAttributes
    ATTRIBUTES = [
      :account_attributes,
      :bounding_box_attributes,
      :category_attributes,
      :context_attributes,
      :contexts_layers_attributes,
      :data_source_attributes,
      :dimension_attributes,
      :folder_attributes,
      :layer_attributes,
      :membership_attributes,
      :preference_attributes,
      :user_attributes
    ]

    mattr_reader *ATTRIBUTES

    @@account_attributes = [
      :name, :subdomain, :users_attributes, :logo, :default
    ]

    @@bounding_box_attributes = [
      :crs, :maxx, :maxy, :minx, :miny
    ]

    @@category_attributes = [
      :name, :position, :parent_id
    ]

    @@contexts_layers_attributes = [
      :id, :position, :opacity, :layer_id, :context_id, :visibility
    ]

    @@context_attributes = [
      :id, :name, :zoom, :description, :center_lng, :center_lat,
      :layer_ids, :uuid, :contexts_layers_attributes, :preview,
      :account_id, :folder_id, :by_default, :slug,
      contexts_layers_attributes: @@contexts_layers_attributes
    ]

    @@data_source_attributes = [
      :csw, :name, :ogc, :wfs, :wms, :rest, :not_internal
    ]

    @@dimension_attributes = [
      :layer_id, :value
    ]

    @@folder_attributes = [
      :name, :visibility
    ]

    @@layer_attributes = [
      :description, :name, :title, :wms_url, :data_source_id, :category_ids,
      :category, :crs, :minx, :miny, :maxx, :maxy, :dimension, :template,
      :remote_thumbnail_url, :metadata_url, :metadata_identifier,
      :tiled, :max_zoom 
    ]

    @@membership_attributes = [
      :account, :user
    ]

    @@preference_attributes = [
      :name, :value, :longitude, :latitude, :zoom, :crs, :host, :prefix_uri
    ]

    @@user_attributes = [
      :email, :password, :password_confirmation, :username, :account,
      :account_id, :first_name, :last_name, :email_md5
    ]

  end
end