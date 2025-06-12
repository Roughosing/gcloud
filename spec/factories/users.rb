FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    # Always create root folder after user creation
    after(:create) do |user|
      # Only create if it doesn't exist
      unless user.folders.exists?(name: "My Files", parent_id: nil)
        user.folders.create!(name: "My Files")
      end
    end

    # This trait is now redundant since we always create the root folder
    # but keeping it for backward compatibility
    trait :with_root_folder do
      # Empty since root folder is now created by default
    end
  end
end
