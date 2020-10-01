class AddTranslatorToTranslations < ActiveRecord::Migration[6.0]
  def change
    add_column :translation_manager_translations, :translator_id, :integer
  end
end
