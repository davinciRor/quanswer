class CalculateReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    reputation = Reputation.calculation(object)
    object.user.update(reputation: reputation)
  end
end
