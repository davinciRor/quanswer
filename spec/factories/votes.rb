FactoryGirl.define do
  factory :vote do
    mark 1
    user
    association :votable, factory: :question
  end
end
