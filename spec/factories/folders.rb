FactoryBot.define do
  factory :folder do
    sequence(:name) { |n| "Folder #{n}" }
    association :user

    trait :with_parent do
      transient do
        parent_folder { nil }
      end

      after(:build) do |folder, evaluator|
        folder.parent = evaluator.parent_folder || create(:folder, user: folder.user)
      end
    end

    trait :with_files do
      transient do
        files_count { 3 }
      end

      after(:create) do |folder, evaluator|
        create_list(:file_entry, evaluator.files_count, folder: folder, user: folder.user)
      end
    end

    trait :with_subfolders do
      transient do
        subfolders_count { 2 }
      end

      after(:create) do |folder, evaluator|
        create_list(:folder, evaluator.subfolders_count, parent: folder, user: folder.user)
      end
    end
  end
end
