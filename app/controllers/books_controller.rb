class BooksController < ApplicationController
  def index
    @books = Book.all
    render :inline => BooksPage.new(@books).to_html
  end
end
