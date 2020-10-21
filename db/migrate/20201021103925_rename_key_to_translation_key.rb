class RenameKeyToTranslationKey < ActiveRecord::Migration[6.0]
  def change
    rename_column :translation_manager_translations, :key, :translation_key
  end
end
