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
    @book = Book.find(params[:id])
    @lending_history = LendingHistory.find_by(book_id: @book.id, returned_on: nil)
    @lending_history.update(returned_on: Time.now)
    @book.update(available: true)
    redirect_to @book, notice: "Book returned successfully!"
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :available)
  end
end
