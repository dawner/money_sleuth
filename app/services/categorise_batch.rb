class CategoriseBatch
  include Interactor

  def call
    transaction_batch = context.transaction_batch

    if transaction_batch.valid?
      TransactionBatch.transaction do
        # TODO move this out of controller categorized_file = TransactionCategorizer.call(batch)
        # TODO Extract batch.bank headers into transaction fields
        default_category = Category.default
        bank_format_options = {skip_lines: 1, remove_unmapped_keys: true, headers_in_file: false, user_provided_headers: [:posted_on, :type, :description, :memo, :value]}
        bank_csv = SmarterCSV.process(transaction_batch.bank_file.current_path, bank_format_options)
        bank_csv.each do |line|
          # Find first category which has keywords matching the line description
          # TODO definitely need to make this smarter
          transaction = transaction_batch.transactions.new(line.slice(:posted_on, :description, :value))
          best_category_match = Category.where('keywords && array[?]', transaction.description.downcase.split).first
          transaction.category =  best_category_match || default_category
          transaction.posted_on = DateTime.strptime(line[:posted_on], '%m/%d/%Y')
          transaction.value = line[:value].to_i
          transaction.save!
        end
      end
    else
      context.fail!({errors: transaction_batch.errors})
    end
  end
end
