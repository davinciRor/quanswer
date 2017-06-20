class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :mark, presence: true
  validates :mark, inclusion: { in: [1, -1] }
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id], message: 'You already voted!' }
end
