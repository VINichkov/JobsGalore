Rails.application.routes.draw do
  resources :gateways
  get '/gatetway/execute/:id', to: "gateways#execute", as: "gateway_execute"
  get 'robot', to: 'index#robot'
  get 'sitemap', to: 'index#sitemap'
  get 'sitemap:id', to: 'index#sitemaps'

  devise_for  :clients, controllers:{ registrations: "clients/registrations",
                                      omniauthcallbacks: "clients/omniauthcallbacks",
                                      passwords: "clients/passwords",
                                      confirmations: "clients/confirmations",
                                      sessions: "clients/sessions",
                                      unlocks: "clients/unlocks",
                                      omniauth_callbacks: 'clients/omniauth_callbacks' }
  #devise_scope :client do
  #  get "/sign_up_employer" => "clients/registrations#sign_up_employer"
  #  post '/create_employer'=> "clients/registrations#create_employer"
  #end



  #devise_for :clients

  resources :companies, only: [:new,:create, :show, :edit, :update, :destroy]
  get "/edit_logo", to: 'companies#edit_logo'
  get "/settings_company", to: 'companies#settings_company'
  get '/company_jobs/:id', to:'companies#company_jobs', as: 'jobs_at_company'
  patch '/update_logo', to:"companies#update_logo", as: 'update_logo'

  resources :clients, only: [:create, :edit, :update]#, :destroy
  get '/team/new/', to: 'clients#new_member', as: 'team_new'
  post '/team/', to: 'clients#create_member', as: 'team_create'
  delete '/team/:id', to: 'clients#destroy_member', as: 'team_destroy'
  get "/edit_photo", to: 'clients#edit_photo'
  get '/profile/jobs', to: 'clients#jobs', as:  'jobs_root'
  get '/profile/resumes', to: 'clients#resumes', as:  'resumes_root'
  get "/settings", to: 'clients#settings'
  get "/team/", to: 'clients#team', as: 'team'
  get  '/team_change/:id', to: 'clients#change_type', as: 'change_type'
  patch '/update_photo', to:"clients#update_photo", as: 'update_photo'

  resources :locations
  get '/search_locations/:query', to: 'locations#search'
  get 'in_location/:location/:object', to: 'locations#in_location', as: "local_object"

  #Dictionary
  get '/dictionary/:query', to: 'dictionaries#search'

  #payment
  get '/bill', to: 'payments#bill'
  get '/cancel_url', to: 'payments#cancel_url'
  resources :payments, only: [:create]

  #ADMINISTRATION CLIENTS
  get '/admin/customers/', to: 'clients#admin_index', as: 'admin_client'
  get '/admin/customers/edit_photo/:id', to: 'clients#admin_edit_photo', as: 'admin_client_edit_photo'
  get '/admin/customers/new', to: 'clients#admin_new', as: 'admin_client_new'
  get '/admin/customers/:id', to: 'clients#admin_show', as: 'admin_client_show'
  get '/admin/customers/:id/edit', to: 'clients#admin_edit', as: 'admin_client_edit'
  post '/admin/customers/', to: 'clients#admin_create', as: 'admin_client_create'
  patch '/admin/customers/:id', to: 'clients#admin_update', as: 'admin_client_update'
  delete '/admin/customers/:id', to: 'clients#admin_destroy', as: 'admin_client_destroy'
  get '/admin/', to: 'index#admin', as: "admin"

  #ADMINISTRATION COMPANIES
  get '/admin/companies/', to: 'companies#admin_index', as: 'admin_company'
  get '/admin/companies/edit_logo/:id', to: 'companies#admin_edit_logo', as: 'admin_company_edit_logo'
  get '/admin/companies/new', to: 'companies#admin_new', as: 'admin_company_new'
  get '/admin/companies/:id', to: 'companies#admin_show', as: 'admin_company_show'
  get '/admin/companies/:id/edit', to: 'companies#admin_edit', as: 'admin_company_edit'
  post '/admin/companies/', to: 'companies#admin_create', as: 'admin_company_create'
  patch '/admin/companies/:id', to: 'companies#admin_update', as: 'admin_company_update'
  delete '/admin/companies/:id', to: 'companies#admin_destroy', as: 'admin_company_destroy'

  #ADMINISTRATION  Team
  get '/admin/team/new/:id', to: 'companies#admin_new_member', as: 'admin_team_new'#+
  get '/admin/team/edit/:id', to: 'companies#admin_edit_member', as: 'admin_team_edit'#+
  patch '/admin/team/update/:id', to: 'companies#admin_update_member', as: 'admin_team_update'#+
  post '/admin/team/', to: 'companies#admin_create_member', as: 'admin_team_create'#+
  delete '/admin/team/:id', to: 'companies#admin_destroy_member', as: 'admin_team_destroy'#+
  get '/admin/team/:id', to: 'companies#client_in_company_index', as: 'admin_company_team'#+
  get '/admin/member_of_team/:id', to: 'companies#admin_show_member_of_team', as: 'admin_member_show'#+

  #ADMINISTRATION Jobs
  get '/admin/member/:id', to: 'companies#admin_index_job', as: 'admin_index_job'#+
  get '/admin/members/jobs/new/:id', to: 'companies#admin_new_job', as: 'admin_new_job'#+
  post '/admin/members/jobs/', to: 'companies#admin_create_job', as: 'admin_create_job'#+
  get '/admin/members/jobs/:id', to: 'companies#admin_show_job', as: 'admin_show_job'#+
  delete '/admin/members/jobs/:id', to: 'companies#admin_destroy_job', as: 'admin_destroy_job'#+

  #ADMINISTRATION JOBS
  post 'admin/jobs/extras/', to: 'jobs#admin_extras', as: 'admin_job_extras'
  get '/admin/jobs/', to: 'jobs#admin_index', as: 'admin_jobs'
  get '/admin/jobs/new', to: 'jobs#admin_new', as: 'admin_jobs_new'
  get '/admin/jobs/:id', to: 'jobs#admin_show', as: 'admin_jobs_show'
  get '/admin/jobs/:id/edit', to: 'jobs#admin_edit', as: 'admin_jobs_edit'
  post '/admin/jobs/', to: 'jobs#admin_create', as: 'admin_jobs_create'
  patch '/admin/jobs/:id', to: 'jobs#admin_update', as: 'admin_jobs_update'
  delete '/admin/jobs/:id', to: 'jobs#admin_destroy', as: 'admin_jobs_destroy'

  #ADMINISTRATION RESUMES
  post 'admin/resumes/extras/', to: 'resumes#admin_extras', as: 'admin_resume_extras'
  get '/admin/resumes/', to: 'resumes#admin_index', as: 'admin_resumes'
  get '/admin/resumes/new', to: 'resumes#admin_new', as: 'admin_resumes_new'
  get '/admin/resumes/:id', to: 'resumes#admin_show', as: 'admin_resumes_show'
  get '/admin/resumes/:id/edit', to: 'resumes#admin_edit', as: 'admin_resumes_edit'
  post '/admin/resumes/', to: 'resumes#admin_create', as: 'admin_resumes_create'
  patch '/admin/resumes/:id', to: 'resumes#admin_update', as: 'admin_resumes_update'
  delete '/admin/resumes/:id', to: 'resumes#admin_destroy', as: 'admin_resumes_destroy'

  resources :responsibles
  resources :sizes
  resources :industries
  resources :properts, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :payments, only:[:show,:index]

  resources :jobs, only:[:new, :show, :edit, :update, :destroy]
  post "job_create/", to: "jobs#create_temporary", as: 'create_job'
  get "jobs/", to: "jobs#create_job", as: 'jobs'

  resources :resumes, only:[:new, :show, :edit, :update, :destroy]
  post "resume_create/", to: "resumes#create_temporary", as: 'create_resume'
  get "resumes/", to: "resumes#create_resume", as: 'resumes'

  get "/log_in/:id", to: "resumes#log_in", as: 'log_in'
  root  to: 'index#main'
  get "/terms_and_conditions", to: 'index#terms_and_conditions'
  get "/privacy", to: 'index#privacy'
  get "/about", to: 'index#about'
  get "/contact", to: 'index#contact'
  get "/advertising_terms_of_use", to: 'index#advertising_terms_of_use'
  post "/send", to: 'index#send_mail'
  post "/send_customers", to: 'index#send_to_customers'
  get "/send_offer", to:'index#send_offer'
  get '/search', to: 'index#main_search'
  get '/by_category/:obj', to: 'index#by_category'
  get '/:category/:object', to: 'index#category_view'




  #resources :educations
  #resources :languageresume
  #resources :experiences
  #resources :industryexperiences
  #resources :skillsjobs
  #resources :skillsresumes
  #resources :languages
  #resources :level



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
