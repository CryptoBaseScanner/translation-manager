# frozen_string_literal: true

class CreateTranslationManagerTranslations < ActiveRecord::Migration[6.0]
  def change
    create_table :translation_manager_translations do |t|
      t.string :key, null: false
      t.integer :version, null: false
      t.string :value, default: '', null: false
      t.string :language, null: false
      t.string :namespace, null: false

      t.timestamps
    end

    add_index :translation_manager_translations, %i[key version namespace language], name: 'main_index', unique: true
  end
end
