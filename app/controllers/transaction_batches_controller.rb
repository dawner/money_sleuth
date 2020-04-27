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

  # GET /transaction_batches/1/edit
  def edit
  end

  # POST /transaction_batches
  # POST /transaction_batches.json
  def create
    @transaction_batch = TransactionBatch.new(transaction_batch_params)

    respond_to do |format|
      if @transaction_batch.save
        format.html { redirect_to @transaction_batch, notice: 'Transaction batch was successfully created.' }
        format.json { render :show, status: :created, location: @transaction_batch }
      else
        format.html { render :new }
        format.json { render json: @transaction_batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_batches/1
  # PATCH/PUT /transaction_batches/1.json
  def update
    respond_to do |format|
      if @transaction_batch.update(transaction_batch_params)
        format.html { redirect_to @transaction_batch, notice: 'Transaction batch was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction_batch }
      else
        format.html { render :edit }
        format.json { render json: @transaction_batch.errors, status: :unprocessable_entity }
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
      @transaction_batch = TransactionBatch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_batch_params
      params.require(:transaction_batch).permit(:bank_file, :bank_id)
    end
end
