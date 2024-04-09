class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.string :feature_id
      t.string :string
      t.string :body
      t.string :string

      t.timestamps
    end
  end
end
