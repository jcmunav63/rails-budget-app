FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    icon { '/images/icons/icon.png' }
    total_expenses { '0.00' }
    association :user
  end
end
