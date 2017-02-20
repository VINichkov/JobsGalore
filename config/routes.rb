Rails.application.routes.draw do
  resources :companies
  root 'index#main'
  resources :locations
  resources :jobs
  resources :educations
  resources :languageresumes
  resources :resumes
  resources :experiences
  resources :industryexperiences
  resources :skillsjobs
  resources :skillsresumes
  resources :levels
  resources :languages
  resources :responsibles
  resources :sizes
  resources :industrycompanies
  resources :industryjobs
  resources :industryresumes
  resources :clients
  resources :industries
  resources :properts
  get '/by_category/:obj', to: 'index#by_category'
  get '/:category/:object', to: 'index#category_view'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
