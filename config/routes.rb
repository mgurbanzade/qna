Rails.application.routes.draw do
  resources :questions, only: :new
end
