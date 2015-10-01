class CreateHtmlCodes < ActiveRecord::Migration
  def change
    create_table :html_codes do |t|
      t.text :cadena
      t.text :resultado

      t.timestamps null: false
    end
  end
end
