FactoryGirl.define do
  factory :comment do
    body 'Comment'
    association :commentable, factory: :question
  end
end
