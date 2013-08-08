class Page < Widget
  include ActiveSupport::Configurable
  include ActionController::RequestForgeryProtection
  include Sprockets::Rails::Helper

  attr_accessor :head, :body, :session

  # Copy Sprockets configuration
  self.debug_assets       = ActionView::Base.debug_assets
  self.digest_assets      = ActionView::Base.digest_assets
  self.assets_prefix      = ActionView::Base.assets_prefix
  self.assets_environment = ActionView::Base.assets_environment
  self.assets_manifest    = ActionView::Base.assets_manifest

  def initialize(controller)
    @session = controller.session
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

  # Copied from sprockets, removed the call to `join("\n")`, and replaced the calls to `super`
  # with explicit calls to the vanilla Rails helper
  def javascript_include_tag(*sources)
    options = sources.extract_options!.stringify_keys

    if true # request_debug_assets? && options["debug"] != false
      sources.map { |source|
        if asset = lookup_asset_for_path(source, :type => :javascript)
          asset.to_a.map do |a|
            javascript_include_tag_orig(path_to_javascript(a.logical_path, :debug => true), options)
          end
        else
          javascript_include_tag_orig(source, options)
        end
      }.flatten
    else
      sources.push(options)
      javascript_include_tag_orig(*sources)
    end
  end

  # Copied from sprockets, removed the call to `join("\n")`, and replaced the calls to `super`
  # with explicit calls to the vanilla Rails helper
  def stylesheet_link_tag(*sources)
    options = sources.extract_options!.stringify_keys

    if true # request_debug_assets? && options["debug"] != false
      sources.map { |source|
        if asset = lookup_asset_for_path(source, :type => :stylesheet)
          asset.to_a.map do |a|
            stylesheet_link_tag_orig(path_to_stylesheet(a.logical_path, :debug => true), options)
          end
        else
          stylesheet_link_tag_orig(source, options)
        end
      }.flatten
    else
      sources.push(options)
      stylesheet_link_tag_orig(*sources)
    end
  end

  def javascript_include_tag_orig(*sources)
    options = sources.extract_options!.stringify_keys
    path_options = options.extract!('protocol').symbolize_keys

    sources.uniq.map { |source|
      tag_options = {
        "src" => path_to_javascript(source, path_options)
      }.merge!(options)
      content_tag(:script, "", tag_options)
    }
  end

  def stylesheet_link_tag_orig(*sources)
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
