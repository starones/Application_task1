class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
 attachment :profile_image, destroy: false
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # フォロー機能
  has_many :followers, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :followings, class_name: 'Relationship', foreign_key: 'following_id', dependent: :destroy, inverse_of: :following
  has_many :following_users, through: :followers, source: :following
  has_many :follower_users, through: :followings, source: :follower

  def follow(user_id)
    followers.create(following_id: user_id)
  end

  def unfollow(user_id)
    followers.find_by(following_id: user_id).destroy
  end

  def following?(user)
    following_users.include?(user)
  end
  # ここまで

  # ------検索機能-------
  def self.search(search,word)
    if search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")

    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")

    elsif search == "perfect_match"
      @user = User.where("#{word}")

    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  # ---------ここまで-------

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}, uniqueness: true
end
