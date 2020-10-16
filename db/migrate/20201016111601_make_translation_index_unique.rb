class MakeTranslationIndexUnique < ActiveRecord::Migration[6.0]
  def change
    remove_index :translation_manager_translations, column: %i[version namespace language], name: 'main_index'
    add_index :translation_manager_translations, %i[key version namespace language], name: 'main_index', unique: true
  end
end
