class BookWidget < Widget
  attr_reader :book, :tag

  def initialize(book, tag = :div)
    @book = book
    @tag  = tag
  end

  def to_hexp
    H[tag, {class: 'book-entry', id: "book-entry-#{book.id}"}, [
        H[:h2, book.title],
        H[:img, src: book.image.url(:medium)],
        H[:span, {class: 'datetime'}, book.date_time.strftime('%e %B %Y at %l:%M %p')],
      ]
    ]
  end
end
