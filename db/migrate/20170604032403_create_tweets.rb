class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets, id: :uuid do |t|
      t.uuid :screenshot_id, null: false
      t.string :tweet_id, null: false
      t.integer :favorites, default: 0, null: false
      t.integer :retweets, default: 0, null: false
      t.timestamps
    end
    add_foreign_key :tweets, :screenshots
  end
end
