class BooksPage < Page

  def initialize(session, books)
    super(session)

    head.concat stylesheet_link_tag('application', media: 'all', 'data-turbolinks-track' => true)
    head.concat javascript_include_tag('application', 'data-turbolinks-track' => true)

    body << H[:h1, 'My Log Book of Books Logged']
    body << H[:div, {class: 'books'}, books]
  end

end
