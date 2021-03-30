class AddLikeCountToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :like_count, :integer, default: 0
  end
end
