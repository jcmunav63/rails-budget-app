FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "testuser#{n}@gmail.com" }
    password { 'me1234' }
    # role { 'default' }
  end
end
