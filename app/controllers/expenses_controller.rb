class ExpensesController < ApplicationController

  def index
    @expenses = {}
    expense_sum = Transaction.joins(:category)
      .where(category: { transaction_type: :expense })
      .group(:category)
      .sum(:value_cents)
      .reduce(0) do |sum, (category, value_cents)|
        expense = -value_cents
        @expenses[category] = Money.new(expense)
        sum + expense
      end


    @total = Money.new(expense_sum)
  end
end
