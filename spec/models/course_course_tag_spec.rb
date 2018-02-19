require 'rails_helper'

RSpec.describe CourseCourseTag, type: :model do
  subject { build :course_course_tag }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  describe 'after create' do
    it 'adds tag into cache for course' do
      subject.save
      course = subject.course
      course.reload
      expect(course.tags_cache).to eq([subject.course_tag.name])
    end
  end

  describe 'after destroy' do
    before(:each) do
      subject.save
      subject.course.reload
    end

    it 'removes tag from cache for course' do
      subject.destroy
      course = subject.course
      course.reload
      expect(course.tags_cache).to eq([])
    end
  end
end
