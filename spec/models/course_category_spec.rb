require 'rails_helper'

RSpec.describe CourseCategory, type: :model do
  subject { build :course_category }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  it_behaves_like 'normalizes_priority', (1..500)
  it_behaves_like 'requires_name'
  it_behaves_like 'limits_max_name_length', 50
  it_behaves_like 'limits_max_slug_length', 50
  it_behaves_like 'rejects_invalid_slug', 'invalid slug'
  it_behaves_like 'normalizes_blank_slug_using_name', 'ПРОВЕРКА', 'proverka'
  it_behaves_like 'normalizes_existing_slug', 'Test', 'test'

  describe 'after initialize' do
    it 'sets next priority' do
      subject.save!
      entity = CourseCategory.new(parent: subject.parent)
      expect(entity.priority).to eq(subject.priority + 1)
    end
  end

  describe 'after create' do
    it 'caches parents' do
      entity = create(:course_category, parent: subject)
      expect(entity.parents_cache).to eq(subject.id.to_s)
    end

    it 'caches parent children' do
      entity = create(:course_category, parent: subject)
      expect(subject.children_cache).to eq([entity.id])
    end
  end

  describe 'before validation' do
    it 'generates long slug' do
      subject.save!
      entity = build(:course_category, parent: subject)
      entity.valid?
      expect(entity.long_slug).to eq("#{subject.slug}_#{entity.slug}")
    end
  end

  describe 'validation' do
    it 'fails with non-unique slug for the same parent' do
      subject.slug = 'test'
      create :course_category, slug: subject.slug, parent: subject.parent
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'passes with non-unique slug for foreign parent' do
      subject.slug   = 'test'
      entity         = create :course_category, slug: subject.slug
      subject.parent = entity
      expect(subject).to be_valid
    end

    it 'fails with non-unique name in siblings' do
      create :course_category, name: subject.name, slug: 'other'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'passes with non-unique name outside same parent' do
      parent = create :course_category
      create :course_category, name: subject.name, slug: 'other', parent: parent
      expect(subject).to be_valid
    end
  end
end
