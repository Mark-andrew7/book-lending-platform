class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
  end

  def show
    @lending_history = @book.lending_histories
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: "Book was successfully destroyed."
  end

  def borrow
    @book = Book.find(params[:id])
    if @book.available
      @book.update(available: false)
      LendingHistory.create(book_id: @book.id, borrower_name: params[:borrower_name], borrowed_on: Time.now)
      redirect_to @book, notice: "Book borrowed successfully!"
    else
      redirect_to @book, alert: "This book is already borrowed."
    end
  end

  def return
    @book = Book.find_by(id: params[:id])  # Find the book by id
    if @book
      @book.update(available: true)  # Update the book to available
      redirect_to @book, notice: 'Book was successfully returned.'
    else
      redirect_to books_url, alert: 'Book not found.'
    end
  end
  

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :available)
  end
end
