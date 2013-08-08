class BooksController < ApplicationController
  def index
    @books = Book.all
    render :inline => BooksPage.new(@books).to_html
  end

  def process_mails
    logger = StringIO.new
    Mailman.config.logger = Logger.new(logger)
    MailReader.new(MailReader::Config.from_env).run
    Mailman.config.logger = Logger.new(STDOUT)

    render :inline => logger.string, :content_type => "text/plain"
  end
end
