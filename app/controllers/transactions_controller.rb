class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:update, :destroy]

  VALID_FILTERS = [:category_id, :start_date, :end_date, :year, :month]

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
      format.html { redirect_to (request.referrer || transactions_url), notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def valid_filters
      filters = params.permit(VALID_FILTERS).to_h.symbolize_keys

      filters[:start_date] = start_date(filters)
      filters[:end_date] = end_date(filters)
      filters
    end

    def start_date(filters)
      return filters[:start_date].to_date if filters[:start_date].present?

      if filters[:year]
        Date.new(filters[:year].to_i, filters[:month]&.to_i || 1, 1)
      else
        default_start_date(filters)
      end
    end

    def end_date(filters)
      return filters[:end_date].to_date if filters[:end_date].present?

      if filters[:year]
        Date.new(filters[:year].to_i, filters[:month]&.to_i || 12, 1).end_of_month
      else
        Date.today
      end
    end

    def default_start_date(filters)
      # Default to 1 Jan when category filter applied, and start of previous month when no category filter
      today = Date.today
      filters[:category_id] ? today.beginning_of_year : (Date.today - 1.month).at_beginning_of_month
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
