class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:update, :destroy]


  # PATCH/PUT /transactiones/1
  # PATCH/PUT /transactiones/1.json
  def update
    # TODO rerun categorizer if bank headers changing
    respond_to do |format|
      if @transaction.update(transaction_update_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactiones/1
  # DELETE /transactiones/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactiones_url, notice: 'Transaction was successfully destroyed.' }
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
