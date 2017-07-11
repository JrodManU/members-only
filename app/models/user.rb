class User < ApplicationRecord
  attr_accessor :remember_token

  has_secure_password

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def new_remember_token
    remember_token = User.digest(User.new_token)
    update_attributes(:remember_digest, remember_token)
  end

  def clear_remember_digest
    update_attributes(:remember_digest, nil)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                              BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
