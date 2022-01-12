require 'rails_helper'

RSpec.describe "balance_entries/edit", type: :view do
  before(:each) do
    @balance_entry = assign(:balance_entry, BalanceEntry.create!(
      value: "",
      bank: nil
    ))
  end

  it "renders the edit balance_entry form" do
    render

    assert_select "form[action=?][method=?]", balance_entry_path(@balance_entry), "post" do

      assert_select "input[name=?]", "balance_entry[value]"

      assert_select "input[name=?]", "balance_entry[bank_id]"
    end
  end
end
