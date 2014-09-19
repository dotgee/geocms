module Geocms
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => [:scoped, :finders], :scope => :account

    has_many :categorizations
    has_many :layers, through: :categorizations
    acts_as_tenant(:account)

    has_ancestry :cache_depth => true
    acts_as_list scope: [:account_id, :ancestry]

    scope :ordered, -> { select([:name, :id, :slug, :ancestry]).ordered_by_ancestry.order("position asc") }

    before_save :cache_ancestry

    class << self

      def for_select
        order(:names_depth_cache).map { |c| ["- " * c.depth + c.name, c.id] }
      end

      def leafs
        all.reject { |c| c.has_children? }
      end
    end

    def cache_ancestry
      self.names_depth_cache = path.map(&:name).join('/')
    end

    def self.arrange_as_array(options={}, hash=nil)
      hash ||= arrange(options)

      arr = []
      hash.each do |node, children|
        arr << node
        arr += arrange_as_array(options, children) unless children.empty?
      end
      arr
    end

    def self.json_tree(nodes)
      nodes.map do |node, sub_nodes|
        { "name" => node.name,
          "id" => node.id,
          "type" => "category",
          "slug" => node.slug,
          "children" => json_tree(sub_nodes).compact
        }
      end
    end

    def type
      "category"
    end

    def serializable_hash(options={})
      options = {
        methods: [:type],
        only: [:name, :id, :slug]
      }.update(options)
      super(options)
    end


    def depth_name
      ("-" * depth) + name
    end

  end
end
