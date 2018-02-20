FactoryBot.define do
  factory :course do
    course_category
    sequence(:title) { |n| "Курс #{n}" }
    description "Описание ещё одного курса"
  end
end
