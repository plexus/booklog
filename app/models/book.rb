class Book < ActiveRecord::Base
  has_attached_file :image,
                    storage: :database,
                    database_table: 'book_images',
                    styles: { medium: "300x300>", thumb: "100x100>" }

  def self.by_date
    self.all.sort_by(&:date_time).reverse
  end

  def self.create_from_message!(message)
    file = nil

    unless message.attachments.empty?
      attachment = message.attachments.first
      file = save_attachment(attachment)
    end

    date = message.text_part.to_s[/date:(.*)/, 1]

    self.create!(
      title: message.subject,
      image: file,
      finish_date: (DateTime.parse(date) if date)
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

  def exif
    EXIFR::JPEG.new(image.to_file(:original).path)
  end

  def date_time
    exif.date_time_original || finish_date
  end
end
