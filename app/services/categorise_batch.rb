class CategoriseBatch
  include Interactor

  def call
    transaction_batch = context.transaction_batch
    institution = transaction_batch.institution

    if transaction_batch.valid?
      TransactionBatch.transaction do
        csv = read_csv(institution, transaction_batch.file.current_path)
        csv.each do |line|
          amount = get_amount(line, institution)
          next unless amount && amount.nonzero? # Remove transactions without a dollar value

          process_line!(line, amount, transaction_batch, institution)
        end
      end
    else
      context.fail!({errors: transaction_batch.errors})
    end
  end

  private

  def read_csv(institution, file_path)
    institution_format_options = {
      remove_unmapped_keys: true,
      headers_in_file: institution.headers_in_file,
      force_utf8: true,
      user_provided_headers: institution.headers
    }

      file = File.open(file_path, "r:bom|utf-8")
      csv = SmarterCSV.process(file, institution_format_options)
      file.close

    csv
  end

  def get_amount(line, institution)
    amount = parse_amount(line[:value], institution)
    return amount if amount && amount.nonzero?

    parse_amount(line[:expense_value], true)
  end

  def parse_amount(raw_value, institution)
    # Strip any $ signs and commas so we can convert to float
    cleaned_value = raw_value.is_a?(String) ? raw_value.gsub(/\$|,/, '') : raw_value
    cleaned_value && (cleaned_value.to_f * (institution.expenses_negative ? 1 : -1))
  end

  def process_line!(line, amount, transaction_batch, institution)
    # Find first category which has keywords matching the line description
    # TODO definitely need to make this smarter
    transaction = transaction_batch.transactions.new(line.slice(:posted_on, :description, :value))
    best_category_match = Category.where('keywords && array[?]', transaction.description.downcase.split).last
    transaction.category =  best_category_match || Category.default
    transaction.posted_on = DateTime.strptime(line[:posted_on], institution.date_format)
    transaction.value = amount
    transaction.save!
  end
end
