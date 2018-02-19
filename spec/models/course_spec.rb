require 'rails_helper'

RSpec.describe Course, type: :model do
  subject { build :course }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  it_behaves_like 'normalizes_priority', (1..999)
  it_behaves_like 'normalizes_existing_slug', 'Test', 'test'
  it_behaves_like 'rejects_invalid_slug', 'Не подходит'
  it_behaves_like 'limits_max_slug_length', 250

  describe 'after initialize' do
    it 'sets next priority' do
      subject.save
      entity = Course.new(course_category_id: subject.course_category_id)
      expect(entity.priority).to eq(subject.priority + 1)
    end
  end

  describe 'before validation' do
    it 'normalizes blank slug using title' do
      subject.title = 'Проверка'
      subject.slug  = ''
      subject.valid?
      expect(subject.slug).to eq('proverka')
    end
  end

  describe 'validation' do
    it 'fails without title' do
      subject.title = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:title)
    end

    it 'fails with too long title' do
      subject.title = 'a' * 251
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:title)
    end

    it 'fails with non-unique title' do
      create :course, title: subject.title
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:title)
    end

    it 'fails with non-unique slug' do
      subject.slug = 'double'
      create :course, slug: subject.slug
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with too long subtitle' do
      subject.subtitle = 'a' * 251
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:subtitle)
    end

    it 'fails with too long meta_title' do
      subject.meta_title = 'a' * 256
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:meta_title)
    end

    it 'fails with too long meta_keywords' do
      subject.meta_keywords = 'a' * 256
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:meta_keywords)
    end

    it 'fails with too long meta_description' do
      subject.meta_description = 'a' * 256
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:meta_description)
    end

    it 'fails with too long duration' do
      subject.duration = 'a' * 51
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:duration)
    end

    it 'fails with too long lead' do
      subject.lead = 'a' * 1001
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:lead)
    end

    it 'fails with too long description' do
      subject.description = 'a' * 50001
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:description)
    end

    it 'fails with too long image_alt_text' do
      subject.image_alt_text = 'a' * 256
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:image_alt_text)
    end

    it 'fails with negative price' do
      subject.price = -1
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:price)
    end

    it 'fails with negative special price' do
      subject.special_price = -1
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:special_price)
    end
  end
end
