class Book < ApplicationRecord
	belongs_to :user
	has_many :book_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy
# 	--------1週間のいいね数多い順-------
  has_many :favorited_users, through: :favorites, source: :user
# ------------ここまで-------

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	# -------検索機能-------
	def self.search(search, word)
        if search == "forward_match"
          @book = Book.where("title LIKE?","#{word}%")
        elsif search == "backward_match"
          @book = Book.where("title LIKE?","%#{word}")
        elsif search == "perfect_match"
          @book = Book.where(title: "#{word}")
        elsif search == "partial_match"
          @book = Book.where("title LIKE?","%#{word}%")
        else
          @book = Book.all
        end
	end
end
# --------ここまで--------
