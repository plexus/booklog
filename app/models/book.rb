class Book < ActiveRecord::Base
  def self.create_from_message!(message)
    self.create!(title: message.subject)
  end
end
