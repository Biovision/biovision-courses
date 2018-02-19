FactoryBot.define do
  factory :course_tag do
    sequence(:name) { |n| "Метка #{n}" }
  end
end
