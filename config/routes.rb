Jukebox::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :searches, :only => [:index]
      resources :tracks, :only => [:index, :create, :destroy]
      resources :playlists, :only => [:show, :create]
    end
  end

  match 'partials/search' => 'angular_views#search'
  match 'partials/playlist' => 'angular_views#playlist'
  match 'partials/player' => 'angular_views#player'
  match 'partials/splash' => 'angular_views#splash'

  resources :searches, :only => [:index]

  root :to => 'pages#index'
end
