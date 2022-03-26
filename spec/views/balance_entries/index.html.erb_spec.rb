require 'rails_helper'

RSpec.describe "balance_entries/index", type: :view do
  before(:each) do
    assign(:balance_entries, [
      BalanceEntry.create!(
        value: "",
        institution: nil
      ),
      BalanceEntry.create!(
        value: "",
        institution: nil
      )
    ])
  end

  it "renders a list of balance_entries" do
    render
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
