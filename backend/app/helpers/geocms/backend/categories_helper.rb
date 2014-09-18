module Geocms
  module Backend::CategoriesHelper

    def nested_categories(categories)
      categories.map do |category, sub_categories|
        render("geocms/backend/categories/category", category: category) + content_tag(:div, nested_categories(sub_categories), :class => "nested_categories")
      end.join.html_safe
    end

    def move_link(path, direction, disabled = false)
      link_to path, :class => "btn btn-default btn-xs #{"disabled" if disabled}" do
        content_tag('span', :class => (direction == "up") ? "glyphicon glyphicon-arrow-up" : "glyphicon glyphicon-arrow-down"){}
      end
    end

  end
end