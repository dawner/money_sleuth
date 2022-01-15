class CategoriseBatch
  include Interactor

  def call
    transaction_batch = context.transaction_batch
    institution = transaction_batch.institution

    if transaction_batch.valid?
      TransactionBatch.transaction do
        # TODO move this out of controller categorized_file = TransactionCategorizer.call(batch)
        # TODO Extract batch.institution headers into transaction fields
        default_category = Category.default
        institution_format_options = {
          remove_unmapped_keys: true,
          headers_in_file: institution.headers_in_file,
          force_utf8: true,
          user_provided_headers: institution.headers
        }
        institution_csv = SmarterCSV.process(transaction_batch.institution_file.current_path, institution_format_options)
        institution_csv.each do |line|
          amount = line[:value].is_a?(String) ? line[:value].gsub(/\$|,/, '').to_f : line[:value]
          next unless amount && amount.nonzero? # Remove transactions without a dollar value

          # Find first category which has keywords matching the line description
          # TODO definitely need to make this smarter
          transaction = transaction_batch.transactions.new(line.slice(:posted_on, :description, :value))
          best_category_match = Category.where('keywords && array[?]', transaction.description.downcase.split).first
          transaction.category =  best_category_match || default_category
          transaction.posted_on = DateTime.strptime(line[:posted_on], institution.date_format)
          transaction.value = amount * (institution.expenses_negative ? 1 : -1)
          transaction.save!
        end
      end
    else
      context.fail!({errors: transaction_batch.errors})
    end
  end
end
