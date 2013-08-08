class BooksController < ApplicationController
  def index
    @books = Book.all
    render :inline => BooksPage.new(@books).to_html
  end

  def process_mails
    MailReader.new(MailReader::Config.from_env).run
    render :inline => 'OK'
  end
end
