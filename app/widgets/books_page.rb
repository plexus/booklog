class BooksPage < Struct.new(:books)
  include Hexp

  def to_hexp
    H[:ul, books.map{|book| H[:li, book.title]}]
  end
end
