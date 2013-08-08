class BooksPage < Struct.new(:books)
  include Hexp

  def to_hexp
    H[:ul, books.map{|book| H[:li, [book.title, H[:image, src: book.image.url]]]}]
  end
end
