class ExpensesController < ApplicationController

  def index
    lines = Transaction.joins(:category)
    expenses = lines.where(category: { transaction_type: :expense })
    income = lines.where(category: { transaction_type: :income })

    @expenses_categories, @expenses_sum = sum_list(expenses)
    @income_categories, @income_sum = sum_list(income)
  end

  private

  def sum_list(transactions)
    categories = {}
    total = transactions.group(:category)
    .sum(:value_cents)
    .reduce(0) do |sum, (category, value_cents)|
      categories[category] = Money.new(value_cents)
      sum + value_cents
    end

    [categories, Money.new(total)]
  end
end
