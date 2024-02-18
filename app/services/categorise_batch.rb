class CategoriseBatch
  include Interactor

  def call
    transaction_batch = context.transaction_batch
    account = transaction_batch.account

    if transaction_batch.valid?
      TransactionBatch.transaction do
        csv = read_csv(account, transaction_batch.file.current_path)
        csv.each do |line|
          amount = get_amount(line, account)
          next unless amount && amount.nonzero? # Remove transactions without a dollar value

          process_line!(line, amount, transaction_batch, account)
        end
        update_batch_period!(transaction_batch)
      end
    else
      context.fail!({errors: transaction_batch.errors})
    end
  end

  private

  def read_csv(account, file_path)
    format_options = {
      remove_unmapped_keys: true,
      headers_in_file: account.headers_in_file,
      force_utf8: true,
      user_provided_headers: account.headers
    }

      file = File.open(file_path, "r:bom|utf-8")
      csv = SmarterCSV.process(file, format_options)
      file.close

    csv
  end

  def get_amount(line, account)
    amount = parse_amount(line[:value], account)
    return amount if amount && amount.nonzero?

    parse_amount(line[:expense_value], account)
  end

  def parse_amount(raw_value, account)
    # Strip any $ signs and commas so we can convert to float
    cleaned_value = raw_value.is_a?(String) ? raw_value.gsub(/\$|,/, '') : raw_value
    cleaned_value && (cleaned_value.to_f * (account.expenses_negative ? 1 : -1))
  end

  def process_line!(line, amount, transaction_batch, account)
    # Find first category which has keywords matching the line description
    # TODO definitely need to make this smarter
    transaction = transaction_batch.transactions.new(line.slice(:posted_on, :description, :value))
    best_category_match = Category.where('keywords && array[?]', transaction.description.downcase.split).last
    transaction.category =  best_category_match || Category.default
    transaction.posted_on = DateTime.strptime(line[:posted_on], account.date_format)
    transaction.value = amount
    transaction.save!
  end

  def update_batch_period!(transaction_batch)
    max_date = transaction_batch.transactions.maximum(:posted_on)
    min_date = transaction_batch.transactions.minimum(:posted_on)

    transaction_batch.update!(period_start: min_date, period_end: max_date)
  end
end
