Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      # Our resources will be listed here
      resources :users, only: %i[show create update destroy]
      resources :tokens, only: %i[create]
    end
  end
end
