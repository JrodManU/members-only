class Post < ApplicationRecord
  belongs_to :user

  validates :title, length: { minimum: 5, maximum: 75 }, presence: true
  validates :body, length: { minimum: 5, maximum: 2000 }, presence: true
end
