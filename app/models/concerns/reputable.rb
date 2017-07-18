module Reputable
  extend ActiveSupport::Concern

  included do
    after_create :update_reputation
  end

  protected

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end