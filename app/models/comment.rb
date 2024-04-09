class Comment < ApplicationRecord
  validates :body, presence: { message: "No puede estar vacio"}

  belongs_to :feature
end
