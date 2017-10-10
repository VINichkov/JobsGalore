class ClientsController < ApplicationController
  load_and_authorize_resource :client
  before_action :set_client, only: [:show, :edit,:update, :destroy, :admin_edit_photo,:admin_show,:admin_edit,:admin_update,:admin_destroy ]
  before_action :authenticate_client!

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all.order(:email).paginate(page: client_params[:page], per_page:21)
  end

  # GET /clients/1
  # GET /clients/1.json
  #def show
  #end

  def edit_photo
    @client=current_client
  end

  def profile
    @client=current_client
  end

  def settings

  end



  # GET /clients/new
  #def new
  #  @client = Client.new
  #end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to settings_path, notice: 'Client was successfully updated.' }
        format.json { render :settings, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.company.destroy_all
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  #admin routs
  def admin_index
    @clients = Client.all.includes(:location).order(:email).paginate(page: params[:page], per_page:21)
  end
  def admin_edit_photo
  end
  def admin_new
    @client = Client.new
  end
  def admin_edit
  end
  def admin_show

  end
  def admin_create
    @client = Client.new(client_params)
    respond_to do |format|
      if @client.save
        format.html { redirect_to admin_client_show_path(@client), notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :admin_new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end
  def admin_update
    respond_to do |format|
      par = client_params
      if par[:password]
        par.delete(:password)
      end
      if @client.update(par)
        format.html { redirect_to admin_client_show_path(@client), notice: 'Client was successfully updated.' }
        format.json { render :settings, status: :ok, location: @client }
      else
        format.html { render :admin_edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end
  def admin_destroy
    @client.company.destroy_all
    @client.destroy
    respond_to do |format|
      format.html { redirect_to admin_client_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
        params.require(:client).permit(:firstname, :lastname, :email, :phone, :password, :character, :photo, :gender, :location_id, :birth, :page)
    end
end
