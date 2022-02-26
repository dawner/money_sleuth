class CategoriseBatch
  include Interactor

  def call
    transaction_batch = context.transaction_batch
    institution = transaction_batch.institution

    if transaction_batch.valid?
      TransactionBatch.transaction do
        csv = read_csv(institution, transaction_batch.file.current_path)
        csv.each do |line|
          amount = line[:value].is_a?(String) ? line[:value].gsub(/\$|,/, '').to_f : line[:value]
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

  def process_line!(line, amount, transaction_batch, institution)
    # Find first category which has keywords matching the line description
    # TODO definitely need to make this smarter
    transaction = transaction_batch.transactions.new(line.slice(:posted_on, :description, :value))
    best_category_match = Category.where('keywords && array[?]', transaction.description.downcase.split).first
    transaction.category =  best_category_match || Category.default
    transaction.posted_on = DateTime.strptime(line[:posted_on], institution.date_format)
    transaction.value = amount * (institution.expenses_negative ? 1 : -1)
    transaction.save!
  end
end
