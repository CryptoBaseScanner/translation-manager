# frozen_string_literal: true

require 'rails_helper'

module TranslationManager
  RSpec.describe Suggestion, type: :model do
    let(:translation) { create(:translation) }
    let(:suggestion) { create(:suggestion, translation: translation) }
    let(:suggestion2) { create(:suggestion, translation: translation) }

    it 'become approved when gets most approvals' do
      create(:approval, suggestion: suggestion2)
      create(:approval, suggestion: suggestion)
      create(:approval, suggestion: suggestion)
      expect(suggestion.reload).to be_approved
      expect(suggestion2.reload).not_to be_approved
    end
  end
end