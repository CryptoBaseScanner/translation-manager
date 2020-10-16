class ChangeStringFieldsToText < ActiveRecord::Migration[6.0]
  def up
    change_column :translation_manager_suggestions, :suggestion, :text, default: nil
    change_column :translation_manager_translations, :value, :text, default: nil

    case ActiveRecord::Base.connection.adapter_name
    when "MySQL", "Mysql2"
      execute "ALTER TABLE `translation_manager_suggestions` CHANGE `suggestion` `suggestion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT ''"
      execute "ALTER TABLE `translation_manager_translations` CHANGE `value` `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT ''"
    when "SQLite"
      # do nothing since SQLite does not support changing the database encoding and only supports unicode charsets
    when "PostgreSQL"
      # do nothing since PostgreSQL does not support changing the database encoding
    end
  end

  def down
    change_column :translation_manager_suggestions, :suggestion, :string, default: nil
    change_column :translation_manager_translations, :value, :string, default: nil
  end
end
