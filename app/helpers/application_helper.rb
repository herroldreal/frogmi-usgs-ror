module ApplicationHelper
  def add_vue_props(data)
    return unless data.present?

    "data-props=#{data.to_json}"
  end
end
