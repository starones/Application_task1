class BooksController < ApplicationController

  impressionist :actions => [:show, :index], unique: [:ip_address]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @newbook = Book.new
    @book_comment = BookComment.new
    #更新しても閲覧数がカウントしないように設定したため下記と上記「, unique: [:ip_address]」を消すと閲覧数は上がる
    impressionist(@book, nil, unique: [:ip_address])

    # DM機能
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end


  def index
    @books = Book.left_joins(:favorites).group(:id).order(Arel.sql('count(book_id) desc'))
    @book = Book.new
    
    
    # ----新着順と評価順----
    if params[:sort_create]
      @books = Book.latest
    elsif params[:sort_evaluation]
      @books = Book.evaluation
    elsif params[:sort_favorite]
          @books = Book.left_joins(:favorites).group(:id).order(Arel.sql('count(book_id) desc'))
    else
      @books = Book.all
    end

  end


  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
   if @book.user == current_user
    render "edit"
   else
    redirect_to books_path
   end
  end



  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end


  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

end
