class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:update, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
    @transactions = @transactions.where(category_id: params[:category_id]) if params[:category_id]
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    # TODO rerun categorizer if bank headers changing
    respond_to do |format|
      if @transaction.update(transaction_update_params)
        format.js { render json: nil, status: :ok }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_update_params
      params.require(:transaction).permit(:category_id)
    end
end
