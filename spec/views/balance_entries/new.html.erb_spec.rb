require 'rails_helper'

RSpec.describe "balance_entries/new", type: :view do
  before(:each) do
    assign(:balance_entry, BalanceEntry.new(
      value: "",
      bank: nil
    ))
  end

  it "renders new balance_entry form" do
    render

    assert_select "form[action=?][method=?]", balance_entries_path, "post" do

      assert_select "input[name=?]", "balance_entry[value]"

      assert_select "input[name=?]", "balance_entry[bank_id]"
    end
  end
end
