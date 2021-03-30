class Dog < ApplicationRecord
  has_many_attached :images

  belongs_to :owner, foreign_key: 'user_id', class_name: 'User'
end
