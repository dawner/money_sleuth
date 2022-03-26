class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:update, :destroy]

  VALID_FILTERS = [:category_id, :start_date, :end_date]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
    @oldest_date = @transactions.minimum(:posted_on)

    @filters = valid_filters
    @transactions = @transactions.where(posted_on: @filters[:start_date]..@filters[:end_date] )
    @transactions = @transactions.where(category_id: @filters[:category_id]) if @filters[:category_id]
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    # TODO rerun categorizer if institution headers changing
    respond_to do |format|
      if @transaction.update(transaction_update_params)
        format.js { render json: nil, status: :ok } #TODO toast notification of success/error
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.js { render json: nil, status: :unprocessable_entity }
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def valid_filters
      filters = params.permit(VALID_FILTERS).to_h.symbolize_keys
      filters[:start_date] = filter_date(filters[:start_date], (Date.today - 1.month).at_beginning_of_month)
      filters[:end_date] = filter_date(filters[:end_date], Date.today)
      filters
    end

    def filter_date(date_from_params, default_date)
      date_from_params ? date_from_params.to_date : default_date
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_update_params
      params.require(:transaction).permit(:category_id)
    end
end
