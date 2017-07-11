class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :posts

  before_save :downcase_email

  has_secure_password

  validates :name, length: { minimum: 5, maximum: 25 }, presence: true
  validates :password, length: { minimum: 8, maximum: 50 }, presence: true
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def new_remember_token
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def clear_remember_digest
    update_attribute(:remember_digest, nil)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                              BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private
    def downcase_email
      self.email.downcase!
    end
end
