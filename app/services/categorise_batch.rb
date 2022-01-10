class CategoriseBatch
  include Interactor

  def call
    transaction_batch = context.transaction_batch
    bank = transaction_batch.bank

    if transaction_batch.valid?
      TransactionBatch.transaction do
        # TODO move this out of controller categorized_file = TransactionCategorizer.call(batch)
        # TODO Extract batch.bank headers into transaction fields
        default_category = Category.default
        bank_format_options = {
          remove_unmapped_keys: true,
          headers_in_file: bank.headers_in_file,
          force_utf8: true,
          user_provided_headers: bank.headers
        }
        bank_csv = SmarterCSV.process(transaction_batch.bank_file.current_path, bank_format_options)
        bank_csv.each do |line|
          amount = line[:value].is_a?(String) ? line[:value].gsub(/\$|,/, '').to_f : line[:value]
          next unless amount && amount.nonzero? # Remove transactions without a dollar value

          # Find first category which has keywords matching the line description
          # TODO definitely need to make this smarter
          transaction = transaction_batch.transactions.new(line.slice(:posted_on, :description, :value))
          best_category_match = Category.where('keywords && array[?]', transaction.description.downcase.split).first
          transaction.category =  best_category_match || default_category
          transaction.posted_on = DateTime.strptime(line[:posted_on], bank.date_format)
          transaction.value = amount * (bank.expenses_negative ? 1 : -1)
          transaction.save!
        end
      end
    else
      context.fail!({errors: transaction_batch.errors})
    end
  end
end
