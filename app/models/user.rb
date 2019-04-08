class User < ApplicationRecord
  has_many :sessions
  has_many :tweets

  validates :username, length: { maximum: 64, minimum: 3 }, presence: true, uniqueness: true
  validates :password, length: { maximum: 64, minimum: 8 }, presence: true
  validates :email, length: { maximum: 500, minimum: 5 }, presence: true, uniqueness: true

  after_validation :hash_password

  private

  def hash_password
    self.password = BCrypt::Password.create(self.password)
  end

end
