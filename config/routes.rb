Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :rateable do
    member do
      post :like
      post :dislike
    end
  end

  resources :questions, except: :new, concerns: [:rateable] do
    resources :answers, only: [:create, :destroy, :update], shallow: true, concerns: [:rateable] do
      member do
        patch :best_answer
      end
    end
  end

  resources :attachments, only: :destroy
end
