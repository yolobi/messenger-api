FactoryBot.define do
  factory :chat do
    message { Faker::Lorem.sentence }
    is_read false
    association :conversation
    association :user
  end
end
