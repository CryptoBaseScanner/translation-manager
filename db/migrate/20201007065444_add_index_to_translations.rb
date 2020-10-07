class AddIndexToTranslations < ActiveRecord::Migration[6.0]
  def change
    rename_index :translation_manager_translations, 'main_index', 'main_key'
    add_index :translation_manager_translations, %i[version namespace language], name: 'main_index'
  end
end
