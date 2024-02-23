FactoryBot.define do
  factory :expense do
    association :author, factory: :user
    name { 'MyString' }
    amount { 9.99 }
  end
end
