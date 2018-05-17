Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'questions#index'

  concern :rateable do
    member do
      post :like
      post :dislike
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, except: :new, concerns: [:rateable, :commentable] do
    resources :answers, only: [:create, :destroy, :update], shallow: true, concerns: [:rateable, :commentable] do
      member do
        patch :best_answer
      end
    end
  end

  resources :attachments, only: :destroy
end
