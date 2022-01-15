class TransactionBatchesController < ApplicationController
  before_action :set_transaction_batch, only: [:show, :edit, :update, :destroy]

  # GET /transaction_batches
  # GET /transaction_batches.json
  def index
    @transaction_batches = TransactionBatch.all
  end

  # GET /transaction_batches/1
  # GET /transaction_batches/1.json
  def show
  end

  # GET /transaction_batches/new
  def new
    @transaction_batch = TransactionBatch.new
  end

  # POST /transaction_batches
  # POST /transaction_batches.json
  def create
    @transaction_batch = TransactionBatch.create(transaction_batch_create_params)

    result = CategoriseBatch.call({ transaction_batch: @transaction_batch })
    respond_to do |format|
      if result.success?
        format.html { redirect_to @transaction_batch, notice: 'Transaction batch was successfully created.' }
        format.json { render :show, status: :created, location: @transaction_batch }
      else
        format.html { render :new }
        format.json { render json: result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_batches/1
  # DELETE /transaction_batches/1.json
  def destroy
    @transaction_batch.destroy
    respond_to do |format|
      format.html { redirect_to transaction_batches_url, notice: 'Transaction batch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_batch
      @transaction_batch = TransactionBatch.includes(transactions: :category).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_batch_create_params
      params.require(:transaction_batch).permit(:file, :file_cache, :institution_id)
    end
    def transaction_batch_update_params
      params.require(:transaction_batch).permit(:institution_id)
    end
end
