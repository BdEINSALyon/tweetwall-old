class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :author
      t.string :author_image
      t.string :content
      t.string :resource_type
      t.string :resource
      t.string :twitter_id
      t.boolean :published

      t.timestamps null: false
    end
  end
end
