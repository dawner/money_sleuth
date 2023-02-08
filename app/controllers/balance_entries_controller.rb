class BalanceEntriesController < ApplicationController
  before_action :set_balance_entry, only: %i[ show edit update destroy ]

  # GET /balance_entries or /balance_entries.json
  def index
    balance_entries = BalanceEntry.all.select('DISTINCT ON (account_id) balance_entries.*')
      .includes(account: :institution)
      .where(account: { active: true })
      .order(:account_id, posted_on: :desc)
    balance_entries_by_institution = balance_entries.group_by{ |e| e.account.institution }

    @total_value = Money.new(0)
    @total_liquid = Money.new(0)

    @balance_data = balance_entries_by_institution.reduce({}) do |result, (institution, entries)|
      institution_total = Money.new(entries.sum(&:value_cents))
      @total_value += institution_total
      @total_liquid += Money.new(entries.sum{ |e| e.account.liquid? ? e.value_cents : 0 })
      result[institution.name] = { balance_entries: entries, total: institution_total }
      result
    end

    balance_entries_by_account_type = balance_entries.group_by{ |e| e.account.account_type }
    @account_type_data = balance_entries_by_account_type.reduce({}) do |result, (account_type, entries)|
      result[account_type] = Money.new(entries.sum(&:value_cents))
      result
    end

  end

  # GET /balance_entries/new
  def new
    @balance_entry = BalanceEntry.new
  end

  # GET /balance_entries/1/edit
  def edit
  end

  # POST /balance_entries or /balance_entries.json
  def create
    @balance_entry = BalanceEntry.new(balance_entry_params)

    respond_to do |format|
      if @balance_entry.save
        format.html { redirect_to balance_entries_url, notice: "Balance entry was successfully created." }
        format.json { render :show, status: :created, location: @balance_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @balance_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /balance_entries/1 or /balance_entries/1.json
  def update
    respond_to do |format|
      if @balance_entry.update(balance_entry_params)
        format.html { redirect_to balance_entries_url, notice: "Balance entry was successfully updated." }
        format.json { render :show, status: :ok, location: @balance_entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @balance_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /balance_entries/1 or /balance_entries/1.json
  def destroy
    @balance_entry.destroy

    respond_to do |format|
      format.html { redirect_to balance_entries_url, notice: "Balance entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_balance_entry
      @balance_entry = BalanceEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def balance_entry_params
      params.require(:balance_entry).permit(:posted_on, :value, :account_id)
    end
end
