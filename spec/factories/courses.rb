FactoryBot.define do
  factory :course do
    sequence(:title) { |n| "Курс #{n}" }
    description "Описание ещё одного курса"
  end
end
