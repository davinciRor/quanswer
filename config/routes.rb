Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :like
      post :dislike
      delete :unvote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers do
      member do
        patch :make_best
      end
    end
  end

  resources :answers, only: [], concerns: [:votable]

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
