class CreateImages < ActiveRecord::Migration[8.1]
  def change
    create_table :images do |t|
      t.text :prompt, null: false
      t.bigint :seed
      t.string :ai_model

      t.timestamps
    end
  end
end
