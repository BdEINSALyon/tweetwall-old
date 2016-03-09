class AddTimeToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :time, :integer
  end
end
