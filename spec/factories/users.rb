FactoryBot.define do
  factory :user do
    sequence(:screen_name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'secret'
    password_confirmation 'secret'

    factory :course_manager do
      after :create do |user|
        UserPrivilege.create(user: user, privilege: Privilege.find_by!(slug: 'course_manager'))
      end
    end

    factory :chief_course_manager do
      after :create do |user|
        UserPrivilege.create(user: user, privilege: Privilege.find_by!(slug: 'chief_course_manager'))
      end
    end
  end
end
