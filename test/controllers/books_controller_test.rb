require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:book_one)  # Updated to use the new fixture name
  end

  test "should get index" do
    get books_url
    assert_response :success
  end

  test "should create book" do
    assert_difference('Book.count') do
      post books_url, params: { book: { title: 'Test Book', author: 'Test Author', available: true } }
    end
    assert_redirected_to book_url(Book.last)
  end

  test "should borrow book" do
    post borrow_book_url(@book), params: { borrower_name: 'John Doe' }
    assert_redirected_to book_url(@book)
    @book.reload
    assert_not @book.available
  end

  test "should return book" do
    post return_book_url(@book)
    assert_redirected_to book_url(@book)
    @book.reload
    assert @book.available
  end
end
