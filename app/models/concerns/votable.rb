module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def likes
    self.votes.where(mark: 1)
  end

  def dislikes
    self.votes.where(mark: -1)
  end

  def rating
    self.votes.sum(:mark)
  end
end
