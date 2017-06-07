Rails.application.routes.draw do


  devise_for :clients, controllers:{ registrations: "clients/registrations",
                                     omniauthcallbacks: "clients/omniauthcallbacks",
                                     passwords: "clients/passwords",
                                     confirmations: "clients/confirmations",
                                     sessions: "clients/sessions",
                                     unlocks: "clients/unlocks"}
  devise_scope :client do
    get "/sign_up_employer" => "clients/registrations#sign_up_employer"
    post '/create_employer'=> "clients/registrations#create_employer"
  end
  #devise_for :clients
  resources :companies, only: [:show, :edit, :update, :destroy]
  get "/edit_logo", to: 'companies#edit_logo'
  get "/settings_company", to: 'companies#settings_company'
  get '/company_jobs/:id', to:'companies#company_jobs'

  resources :clients, only: [:create, :edit, :update, :destroy]
  get "/edit_photo", to: 'clients#edit_photo'
  get '/profile', to: 'clients#profile', as:  'client_root'
  get "/settings", to: 'clients#settings'

  #resources :locations
  get '/search_locations/:query', to: 'locations#search'



  resources :jobs, only:[:new, :create, :show, :edit, :update, :destroy]
  resources :resumes, only:[:new, :create, :show, :edit, :update, :destroy]
  get "/resumes/:id/log_in", to: "resumes#log_in"
  root  to: 'index#main'
  get "/terms_and_conditions", to: 'index#terms_and_conditions'
  get "/privacy", to: 'index#privacy'
  get "/about", to: 'index#about'
  get "/contact", to: 'index#contact'
  get "/advertising_terms_of_use", to: 'index#advertising_terms_of_use'
  post "/send", to: 'index#send_mail'
  post '/search', to: 'index#main_search'
  get '/by_category/:obj', to: 'index#by_category'
  get '/:category/:object', to: 'index#category_view'
  get '404', :to => 'application#page_not_found'

  #resources :educations
  #resources :languageresume
  #resources :experiences
  #resources :industryexperiences
  #resources :skillsjobs
  #resources :skillsresumes
  #resources :levels
  #resources :languages
  #resources :responsibles
  #resources :sizes
  #resources :industrycompanies
  #resources :industryjobs
  #resources :industryresumes
  resources :industries, only:[:index]
  #resources :properts



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
