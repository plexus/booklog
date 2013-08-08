class Widget
  include Hexp
  include ActionView::Helpers

  def content_tag(tag, content, attrs)
    H[tag, attrs, content]
  end

  def tag(name, options = {}, open = false, escape = true)
    H[name, tag_options(options)]
  end

  def tag_options(options, escape = true)
    return if options.blank?
    attrs = {}
    options.each_pair do |key, value|
      if key.to_s == 'data' && value.is_a?(Hash)
        value.each_pair do |k, v|
          attrs.merge! data_tag_option(k, v, escape)
        end
      elsif BOOLEAN_ATTRIBUTES.include?(key)
        attrs.merge! boolean_tag_option(key) if value
      elsif !value.nil?
        attrs.merge! tag_option(key, value, escape)
      end
    end
    attrs
  end

  def boolean_tag_option(key)
    {key => key}
  end

  def tag_option(key, value, escape)
    {key => value}
  end
end
