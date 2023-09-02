namespace :data do
  desc "Update transaction batch with periods"
  task :update_batch_periods => :environment do
    TransactionBatch.all.order(created_at: :desc).each do |transaction_batch|
      max_date = transaction_batch.transactions.maximum(:posted_on)
      min_date = transaction_batch.transactions.minimum(:posted_on)

      transaction_batch.update!(period_start: min_date, period_end: max_date)
    end
  end
end