require 'rails_helper'

RSpec.shared_examples_for 'rejects_invalid_slug' do |slug|
  describe 'validation' do
    it 'fails when slug does not match pattern' do
      subject.slug = slug
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end
  end
end
