Jukebox::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :searches, :only => [:index]
      resources :tracks, :only => [:index, :create, :destroy]
      resources :playlists, :only => [:show]
    end
  end

  match 'partials/search' => 'angular_views#search'
  match 'partials/playlist' => 'angular_views#playlist'
  match 'partials/player' => 'angular_views#player'

  resources :searches, :only => [:index]

  scope '/mobile' do
    root :to => "pages#mobile", :as => :mobile_root
  end

  root :to => 'pages#index'
end
