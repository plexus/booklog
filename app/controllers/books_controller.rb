class BooksController < ApplicationController
  extend Paperclip::Storage::Database::ControllerClassMethods

  downloads_files_for :book, :image

  def index
    @books = Book.by_date
    render :inline => BooksPage.new(self, @books).to_html
  end

  def process_mails
    logger = StringIO.new
    Mailman.config.logger = Logger.new(logger)
    MailReader.new(MailReader::Config.from_env).run
    Mailman.config.logger = Logger.new(STDOUT)

    render :inline => logger.string, :content_type => "text/plain"
  end

  def test
  end
end
