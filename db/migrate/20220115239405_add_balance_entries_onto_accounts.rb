class AddBalanceEntriesOntoAccounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :balance_entries, :account, foreign_key: true

    # Set account to first account on the institution matching this balance entry
    execute """
    UPDATE balance_entries
    SET account_id = (
      SELECT id
      FROM accounts
      WHERE accounts.institution_id = balance_entries.institution_id
      LIMIT 1
    );
    """

    remove_reference :balance_entries, :institution, foreign_key: true
  end
end
