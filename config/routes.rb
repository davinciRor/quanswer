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
    resources :answers, concerns: [:votable] do
      member do
        patch :make_best
      end
    end
  end

  resources :attachments, only: [:destroy]
end
