require 'rails_helper'

RSpec.shared_examples_for 'normalizes_existing_slug' do |non_normalized, slug|
  describe 'before validation' do
    it 'normalizes existing slug' do
      subject.slug = non_normalized
      subject.valid?
      expect(subject.slug).to eq(slug)
    end
  end
end
