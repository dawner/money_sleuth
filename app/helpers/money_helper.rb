module MoneyHelper
  def format_percent(value, total)
    ((value/total)*100).round
  end
end
