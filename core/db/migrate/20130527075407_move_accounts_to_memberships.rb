class MoveAccountsToMemberships < ActiveRecord::Migration
  def up
    User.all.each do |u|
      u.accounts << Account.find(u.account_id)
      u.save
    end
    remove_column :users, :account_id
  end
end
