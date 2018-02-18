FactoryBot.define do
  factory :course_category do
    sequence(:name) { |n| "Категория курсов #{n}" }
  end
end
