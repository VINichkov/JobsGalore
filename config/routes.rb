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
  resources :companies
  get '/profile', to: 'clients#profile', as:  'client_root'
  root  to: 'index#main'
  resources :locations
  resources :jobs
  #resources :educations
  #resources :languageresumes
  resources :resumes
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
  resources :clients
  #resources :industries
  #resources :properts
  get "/edit_photo", to: 'clients#edit_photo'
  get "/edit_logo", to: 'companies#edit_logo'
  get "/terms_and_conditions", to: 'index#terms_and_conditions'
  get "/privacy", to: 'index#privacy'
  get "/settings", to: 'clients#settings'
  get "/about", to: 'index#about'
  get "/contact", to: 'index#contact'
  get "/advertising_terms_of_use", to: 'index#advertising_terms_of_use'
  get "/settings_company", to: 'companies#settings_company'
  post "/send", to: 'index#send_mail'
  post '/search', to: 'index#main_search'
  get '/search_locations/:query', to: 'locations#search'
  get '/by_category/:obj', to: 'index#by_category'
  get '/company_jobs/:id', to:'companies#company_jobs'
  get '/:category/:object', to: 'index#category_view'
  get '404', :to => 'application#page_not_found'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
