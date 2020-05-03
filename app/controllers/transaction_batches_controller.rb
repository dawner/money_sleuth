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
    @transaction_batch = TransactionBatch.create(transaction_batch_create_params)

    if @transaction_batch.valid?
      TransactionBatch.transaction do
        # TODO move this otu of controller categorized_file = TransactionCategorizer.call(batch)
        # TODO Extract batch.bank headers into transaction fields

        default_category = Category.default
        bank_format_options = {skip_lines: 1, remove_unmapped_keys: true, headers_in_file: false, user_provided_headers: [:posted_on, :description, :skip, :value]}
        bank_csv = SmarterCSV.process(@transaction_batch.bank_file.current_path, bank_format_options)
        bank_csv.each do |line|
          # Find first category which has keywords matching the line description
          # TODO definitely need to make this smarter
          transaction = @transaction_batch.transactions.new(line.slice(:posted_on, :description, :value))
          best_category_match = Category.where('keywords && array[?]', transaction.description.downcase.split).first
          transaction.category =  best_category_match || default_category
          # Make negative values positive TODO skip positive vakues?
          transaction.value = line[:value] && line[:value] * -1
          transaction.save!
        end
      end
    end

    respond_to do |format|
      if @transaction_batch.valid?
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
    # TODO rerun categorizer if bank headers changing
    respond_to do |format|
      if @transaction_batch.update(transaction_batch_update_params)
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
      @transaction_batch = TransactionBatch.includes(transactions: :category).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_batch_create_params
      params.require(:transaction_batch).permit(:bank_file, :bank_file_cache, :bank_id)
    end
    def transaction_batch_update_params
      params.require(:transaction_batch).permit(:bank_id)
    end
end
