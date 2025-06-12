FactoryBot.define do
  factory :file_entry do
    sequence(:name) { |n| "file_#{n}.txt" }
    association :folder
    user { folder.user }

    after(:build) do |file_entry|
      unless file_entry.file.attached?
        file_entry.file.attach(
          io: StringIO.new("Test file content"),
          filename: file_entry.name,
          content_type: "text/plain"
        )
      end
    end

    trait :without_file do
      after(:build) do |file_entry|
        file_entry.file = nil
      end
    end

    trait :with_different_user do
      transient do
        different_user { create(:user) }
      end

      user { different_user }
    end

    trait :image do
      after(:build) do |file_entry|
        file_entry.file.attach(
          io: StringIO.new("Fake image content"),
          filename: "image.jpg",
          content_type: "image/jpeg"
        )
      end
    end

    trait :pdf do
      after(:build) do |file_entry|
        file_entry.file.attach(
          io: StringIO.new("Fake PDF content"),
          filename: "document.pdf",
          content_type: "application/pdf"
        )
      end
    end
  end
end
