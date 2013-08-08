class Page < Widget
  include ActiveSupport::Configurable
  include ActionController::RequestForgeryProtection

  attr_accessor :head, :body, :session

  def initialize(session)
    @session = session
    @head = [*csrf_meta_tags]
    @body = []
  end

  def to_hexp
    H[:html, [
        H[:head, @head],
        H[:body, @body]
      ]
    ]
  end

  def csrf_meta_tags
    if protect_against_forgery?
      [
        tag('meta', :name => 'csrf-param', :content => request_forgery_protection_token),
        tag('meta', :name => 'csrf-token', :content => form_authenticity_token)
      ]
    end
  end

  def javascript_include_tag(*sources)
    options = sources.extract_options!.stringify_keys
    path_options = options.extract!('protocol').symbolize_keys

    sources.uniq.map { |source|
      tag_options = {
        "src" => path_to_javascript(source, path_options)
      }.merge!(options)
      content_tag(:script, "", tag_options)
    }
  end

  def stylesheet_link_tag(*sources)
    options = sources.extract_options!.stringify_keys
    path_options = options.extract!('protocol').symbolize_keys

    sources.uniq.map { |source|
      tag_options = {
        "rel" => "stylesheet",
        "media" => "screen",
        "href" => path_to_stylesheet(source, path_options)
      }.merge!(options)
      tag(:link, tag_options)
    }
  end
end
