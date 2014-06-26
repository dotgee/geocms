module Geocms
  module Concerns::Searchable
    extend ActiveSupport::Concern

    included do
      include Tire::Model::Search
      include Tire::Model::Callbacks
    end

    module ClassMethods
      def define_mapping(&block)
        settings  :analysis => {
                    :analyzer => {
                      :french_analyzer => {
                        "type"         => "custom",
                        "tokenizer"    => "standard",
                        "filter"       => ["lowercase", "asciifolding", "french_stem", "french_stop", "elision"]
                      }
                    },
                    :filter => {
                      :french_stop => {
                        "type" => "stop",
                        "stopwords" => ["_french_"]
                      },
                      :french_stem  => {
                        "type"     => "stemmer",
                        "name" => "french"
                      },
                      :elision => {
                        "type" => "elision",
                        "articles" => ["l", "m", "t", "qu", "n", "s", "j", "d"]
                      }
                    }
                  } do
          mapping do
            block.call
          end
        end
      end

      def search(params)
        tire.search do
          # TODO: Scope by account
          query { string "title:#{params[:query]}" } if params[:query].present?
          size 50
        end
      end
    end

  end
end