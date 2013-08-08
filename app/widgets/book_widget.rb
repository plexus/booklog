class BookWidget < Widget
  attr_reader :book, :tag

  def initialize(book, tag = :div)
    @book = book
    @tag  = tag
  end

  def to_hexp
    H[tag, {class: 'book-entry', id: "book-entry-#{book.id}"}, [
        H[:h2, book.title],
        H[:span, {class: 'datetime'}, book.date_time.to_s],
        H[:image, src: book.image.url(:thumb)]
      ]
    ]
  end
end
