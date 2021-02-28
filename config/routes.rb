Rails.application.routes.draw do
  resources :dns_records, only: [:index, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
