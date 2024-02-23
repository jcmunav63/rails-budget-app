FactoryBot.define do
  factory :category do
    # name { 'MyString' }
    # icon { 'MyString' }
    # total_expenses { '9.99' }
    # user { nil }
    sequence(:name) { |n| "Category #{n}" }
    icon { '/images/icon/icon.png' }
    total_expenses { '0.00' }
    association :user
  end
end
