class ExpensesController < ApplicationController

  def index
    @filters = valid_filters

    lines = Transaction.joins(:category).where('extract(year from posted_on) = ?', @filters[:year])

    lines = lines.where('extract(month from posted_on) = ?', @filters[:month]) if @filters[:month]

    expenses = lines.where(category: { transaction_type: :expense })
    income = lines.where(category: { transaction_type: :income })

    @expenses_categories, @expenses_sum = sum_list(expenses)
    @income_categories, @income_sum = sum_list(income)

    @savings_total = (@income_sum - -@expenses_sum)

    @year_options = Time.now.year.downto(Transaction.minimum(:posted_on).year).to_a
  end

  private


  def valid_filters
    {
      year: params[:year] || Time.now.year,
      month:  params[:month]
    }
  end

  def sum_list(transactions)
    categories = {}
    total = transactions.group(:category)
    .sum(:value_cents)
    .reduce(0) do |sum, (category, value_cents)|
      categories[category] = Money.new(value_cents)
      sum + value_cents
    end


    [categories.sort_by {|_key, value| value}, Money.new(total)]
  end
end
