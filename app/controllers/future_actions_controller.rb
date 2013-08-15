class FutureActionsController < ApplicationController
  before_action :set_future_action, only: [:show, :edit, :update, :destroy]

  # GET /future_actions
  def index
    @future_actions = FutureAction.all
  end

  # GET /future_actions/1
  def show
  end

  # GET /future_actions/new
  def new
    @future_action = FutureAction.new
  end

  # GET /future_actions/1/edit
  def edit
  end

  # POST /future_actions
  def create
    @future_action = FutureAction.new(future_action_params)

    if @future_action.save
      redirect_to @future_action, notice: 'Future action was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /future_actions/1
  def update
    if @future_action.update(future_action_params)
      redirect_to @future_action, notice: 'Future action was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /future_actions/1
  def destroy
    @future_action.destroy
    redirect_to future_actions_url, notice: 'Future action was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_future_action
      @future_action = FutureAction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def future_action_params
      params.require(:future_action).permit(:invoice_id, :sms_notification, :email_notification, :duration_type, :starting_day, :starting_week_day)
    end
end
