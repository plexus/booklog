class Book < ActiveRecord::Base
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }

  def self.create_from_message!(message)

    file = nil

    unless message.attachments.empty?
      attachment = message.attachments.first
      file = save_attachment(attachment)
    end

    self.create!(
      title: message.subject,
      image: file
    )
  end

  def self.save_attachment(attachment)
    fn = attachment.filename
    begin
      file = Tempfile.new(fn)
      file.binmode
      file << attachment.body.decoded
      file
    rescue Exception => e
      logger.error "Unable to save data for #{fn} because #{e.message}"
      nil
    end
  end

end
