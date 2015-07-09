Geocms::Layer.class_eval do
  pg_search_scope :search, against: [:name, :title, :description],
                  :using => {
                    :tsearch => {:dictionary => "french"}
                  },
                  :ignoring => :accents
end