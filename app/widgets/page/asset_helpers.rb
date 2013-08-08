module Page::AssetHelpers
  def self.sprockets_enabled?
    defined?(Sprockets::Rails::Helper) && ActionView::Base.included_modules.include?(Sprockets::Rails::Helper)
  end

  def self.included(klz)
    if sprockets_enabled?
      klz.send(:include, Sprockets::Rails::Helper)
      klz.send(:include, SprocketsHelpers)

      # Copy Sprockets configuration
      klz.debug_assets       = ActionView::Base.debug_assets
      klz.digest_assets      = ActionView::Base.digest_assets
      klz.assets_prefix      = ActionView::Base.assets_prefix
      klz.assets_environment = ActionView::Base.assets_environment
      klz.assets_manifest    = ActionView::Base.assets_manifest
    end
  end

  module SprocketsHelpers
    # Copied from sprockets, removed the call to `join("\n")`, and replaced the calls to `super`
    # with explicit calls to the vanilla Rails helper
    def javascript_include_tag(*sources)
      options = sources.extract_options!.stringify_keys

      if request_debug_assets? && options["debug"] != false
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

      if request_debug_assets? && options["debug"] != false
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

  end

  # Same as the vanilla Rails helper, except it doesn't do a `join("/n")` of the
  # generated tags, so our Hexp nodes don't get turned into strings.
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

  # Same as the vanilla Rails helper, except it doesn't do a `join("/n")` of the
  # generated tags, so our Hexp nodes don't get turned into strings.
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

  # If Sprockets is not available, then use the vanilla helpers
  alias javascript_include_tag javascript_include_tag_orig
  alias stylesheet_link_tag    stylesheet_link_tag_orig
end
