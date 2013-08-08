class ActiveRecord::Base
  def widget_class
    "#{self.class.name}Widget".constantize
  end

  def widget
    widget_class.new(self)
  end

  def to_hexp
    widget.to_hexp
  end
end
