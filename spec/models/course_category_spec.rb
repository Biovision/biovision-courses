require 'rails_helper'

RSpec.describe CourseCategory, type: :model do
  subject { build :course_category }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  describe 'after initialize' do
    it 'sets next priority' do
      subject.save!
      expect(CourseCategory.new.priority).to eq(subject.priority + 1)
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
    it 'normalizes too low priority' do
      subject.priority = 0
      subject.valid?
      expect(subject.priority).to eq(1)
    end

    it 'normalizes too high priority' do
      subject.priority = 501
      subject.valid?
      expect(subject.priority).to eq(500)
    end

    it 'normalizes blank slug' do
      subject.name = 'TEST'
      subject.slug = ''
      subject.valid?
      expect(subject.slug).to eq('test')
    end

    it 'keeps non-blank slug intact (but lower-cased)' do
      subject.name = 'New name'
      subject.slug = 'Test'
      subject.valid?
      expect(subject.slug).to eq('test')
    end

    it 'generates long slug' do
      subject.save!
      entity = build(:course_category, parent: subject)
      entity.valid?
      expect(entity.long_slug).to eq("#{subject.slug}_#{entity.slug}")
    end
  end

  describe 'validation' do
    it 'fails without name' do
      subject.name = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

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

    it 'fails with too long name' do
      subject.name = 'a' * 51
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'fails with too long slug' do
      subject.slug = 'a' * 51
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails when slug does not match pattern' do
      subject.slug = 'invalid slug'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end
  end
end
