Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      # Our resources will be listed here
      resources :users, only: %i[show create update destroy]
      resources :tokens, only: %i[create]
      resources :campaigns do
        resources :discussions, only: %i[show create update destroy] do
          resources :comments, module: :discussions, only: %i[create destroy index]
        end
      end
      resources :discussions, only: %i[index]
      resources :tags, only: %i[index]
    end
  end
end
