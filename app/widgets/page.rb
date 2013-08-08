class Page < Widget
  include ActiveSupport::Configurable
  include ActionController::RequestForgeryProtection
  include Page::AssetHelpers

  attr_accessor :head, :body, :session

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

end
