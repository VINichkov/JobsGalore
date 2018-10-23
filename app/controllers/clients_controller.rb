class ClientsController < ApplicationController
  load_and_authorize_resource :client
  before_action :set_client, only: [:show, :edit,:update, :destroy,:change_type, :linkedin_resume_update, :destroy_member, :admin_edit_photo,:admin_show,:admin_edit,:admin_update,:admin_destroy ]
  before_action :current_company, only: [ :team]
  before_action :set_current_client, only: [:jobs, :resumes, :settings, :edit_photo]
  #before_action :authenticate_client!


  def index
    @clients = Client.all.order(:email).paginate(page: client_params[:page], per_page:21)
  end

  def edit_photo;  end

  def jobs;  end

  def resumes;  end

  def settings;  end

  def change_type
    respond_to do |format|
      if @client.change_type
        format.html { redirect_to team_path, notice: 'Done!' }
      end
    end
  end

  def edit;  end

  def create
    @client = Client.new(client_params)
    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Your profile was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def linkedin_resume_update
    if current_client
      puts "!______________Зашли_______________!"
      if Rails.env.production?
        client = LinkedInClient.new
        @response = client.linkedin_to_h(client.get_profile(current_client.token))
      else
        @response = {:title=>"Administrator JobsGalore.eu",
                     :industry_id=>18,
                     :location_id=>22,
                     :description=>"<p>The website www.JobsGalore.eu allows you to find jobs or talents in Australia.</p><p>You can post jobs on www.jobsgalore.eu free of charge. Please let me know if you are interested.</p><p></p><p>Follow us on Twitter: @JobsGalore_AU</p><p>We'll tweet jobs.</p><p></p><p>Specialties:</p><p>* B2C and B2B Networking.</p><p>* Practical experience in Sales, working in partnership with clients, building relationships to understand my client's objectives.</p><p>* Practical experience in Marketing (including international marketing).</p><p>* Practical experience in Affiliate Marketing (CPI, CPA, CPL).</p><p>* Lead generation, channel marketing, building relationships, PR, events, marketing plan, negotiations, sales, brand awareness, marketing strategy.</p><p>* Multicultural marketing</p><p>* Knowledge of Software IT Market, Finance, Banking products.</p><p>* Software: SalesForce, Jira.</p><p>* Experience of managing a small team.</p><p></p><p>Personal Qualities:</p><p># Strong team player</p><p># Analytical mind</p><p># A highly motivated and hardworking individual.</p><p># Result Oriented and goal-driven.</p><p># Friendly and positive person.</p><p># Good communication skills.</p><h3>Experience</h3><hr><p><strong>Manager Administration - self-employed</strong></p><p><strong>JobsGalore.eu</strong></p><p>Jun 2018 - Present</p><p><strong> Location: </strong>Sydney, Australia</p><p>The website www.JobsGalore.eu allows you to find jobs or talents in Australia.</p><p>You can post jobs on www.jobsgalore.eu free of charge. Please let me know if you are interested.</p><p></p><p>Follow us on Twitter: @JobsGalore_AU</p><p>We'll tweet jobs.</p><p></p><p>Specialties:</p><p>* B2C and B2B Networking.</p><p>* Practical experience in Sales, working in partnership with clients, building relationships to understand my client's objectives.</p><p>* Practical experience in Marketing (including international marketing).</p><p>* Practical experience in Affiliate Marketing (CPI, CPA, CPL).</p><p>* Lead generation, channel marketing, building relationships, PR, events, marketing plan, negotiations, sales, brand awareness, marketing strategy.</p><p>* Multicultural marketing</p><p>* Knowledge of Software IT Market, Finance, Banking products.</p><p>* Software: SalesForce, Jira.</p><p>* Experience of managing a small team.</p><p></p><p>Personal Qualities:</p><p># Strong team player</p><p># Analytical mind</p><p># A highly motivated and hardworking individual.</p><p># Result Oriented and goal-driven.</p><p># Friendly and positive person.</p><p># Good communication skills.</p><hr>",
                     :sources=>"http://www.linkedin.com/in/vladimir-nichkov-915936165"}
      end
    end
    render :linkedin_resume_update, formats: :json
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to settings_path, notice: 'Your profile was successfully updated.' }
        format.json { render :settings, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_photo
    @client=current_client
    param = client_params
    respond_to do |format|
      if param.nil? or @client.update(param)
        format.html { redirect_to settings_path, notice: 'Your profile was successfully updated.' }
        format.json { render :settings, status: :ok, location: @client }
      else
        format.html { render :edit_photo }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Your profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  #admin routs
  def admin_index
    @clients = Client.all.includes(:location).order(:email).paginate(page: params[:page], per_page:21)
  end

  def admin_edit_photo;  end

  def admin_new
    @client = Client.new
  end

  def admin_edit;  end

  def admin_show;  end

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
    @client.company&.destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to admin_client_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def team
    @clients = current_client.object.company.client.all.includes(:location).order(firstname: :desc).paginate(page: params[:page], per_page:25).decorate
  end

  def new_member
    @client = Client.new
  end

  def create_member
    @client=Client.new(client_params.merge({company_id:current_company.id,character: TypeOfClient::EMPLOYEE}))
    respond_to do |format|
      if @client.save
        format.html { redirect_to team_path, notice: 'Done!' }
      else
        format.html { render :new_member }
      end
    end
  end

  def destroy_member
    @client.destroy
    respond_to do |format|
      format.html { redirect_to team_path, notice: 'Done!' }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  def set_current_client
    @client=current_client
  end
    # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    if params[:client]
      params.require(:client).permit(:firstname, :lastname, :email, :phone, :password, :character, :photo, :gender, :location_id, :birth, :send_email, :page)
    end
  end
end
