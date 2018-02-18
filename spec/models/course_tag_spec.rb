require 'rails_helper'

RSpec.describe CourseTag, type: :model do
  subject { build :course_tag }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  it_behaves_like 'requires_name'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'has_unique_slug'
  it_behaves_like 'limits_max_name_length', 50
  it_behaves_like 'limits_max_slug_length', 50
  it_behaves_like 'normalizes_blank_slug_using_name', 'ПРОВЕРКА', 'proverka'
  it_behaves_like 'normalizes_existing_slug', 'Test', 'test'
  it_behaves_like 'rejects_invalid_slug', 'не подходит'
end
