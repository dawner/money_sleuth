class MoveHeadersToAccounts < ActiveRecord::Migration[7.0]
  def up
    add_column :accounts, :headers, :text, array: true, default: []
    add_column :accounts, :headers_in_file, :boolean, default: true
    add_column :accounts, :date_format, :string, default: '%m/%d/%Y'
    add_column :accounts, :expenses_negative, :boolean, default: true

    # Move values from banks to accounts
    execute """
    UPDATE accounts
    SET headers = institutions.headers,
      headers_in_file = institutions.headers_in_file,
      date_format = institutions.date_format,
      expenses_negative = institutions.expenses_negative
    FROM institutions
    WHERE accounts.institution_id = institutions.id;
    """

    remove_column :institutions, :headers
    remove_column :institutions, :headers_in_file
    remove_column :institutions, :date_format
    remove_column :institutions, :expenses_negative
  end

  def down
    add_column :institutions, :headers, :text, array: true, default: []
    add_column :institutions, :headers_in_file, :boolean, default: true
    add_column :institutions, :date_format, :string, default: '%m/%d/%Y'
    add_column :institutions, :expenses_negative, :boolean, default: true

    execute """
    UPDATE institutions
    SET headers = accounts.headers,
      headers_in_file = accounts.headers_in_file,
      date_format = accounts.date_format,
      expenses_negative = accounts.expenses_negative
    FROM accounts
    WHERE accounts.institution_id = institutions.id;
    """

    remove_column :accounts, :headers
    remove_column :accounts, :headers_in_file
    remove_column :accounts, :date_format
    remove_column :accounts, :expenses_negative
  end

end
