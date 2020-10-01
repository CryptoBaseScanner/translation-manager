# frozen_string_literal: true

require 'rails_helper'

module TranslationManager
  RSpec.describe Import, type: :model do
    before { allow(GoogleTranslate).to receive(:translate).and_return('translation by google') }
    let(:import) do
      import = Import.new(namespace: 'test_namespace')
      import.file.attach(
        io: File.open("#{__dir__}/../files/translations.yml"),
        filename: 'translations.yml',
        content_type: 'application/yml'
      )
      import.save!
      import
    end

    it 'saves provided file' do
      expect(import.file).to be_attached
    end

    it { expect(import).to be_processing }

    describe '#import!' do
      let(:user_id) { 1 }

      before do
        import.import!(user_id)
      end

      it { expect(import).to be_finished }

      it 'creates translations' do
        expect(Translation.find_by(namespace: 'test_namespace', language: 'en', key: 'en.translation.key').value)
          .to eq('hello world')
      end

      it 'saves translator' do
        expect(Translation.find_by(namespace: 'test_namespace', language: 'en', key: 'en.translation.key')
          .translator_id).to eq(user_id)
      end
    end
  end
end