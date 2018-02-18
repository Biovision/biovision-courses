require 'rails_helper'

RSpec.shared_examples_for 'normalizes_blank_slug_using_name' do |name, slug|
  describe 'before validation' do
    it 'normalizes blank slug using name' do
      subject.name = name
      subject.slug = ''
      subject.valid?
      expect(subject.slug).to eq(slug)
    end
  end
end
