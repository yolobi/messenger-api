FactoryBot.define do
  factory :conversation_member do
    association :conversation
    association :user
  end
end
