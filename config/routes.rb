Rails.application.routes.draw do
  resources :movies, only: [:index] do
    collection { post :import }
  end
end
