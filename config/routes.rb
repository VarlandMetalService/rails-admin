Admin::Engine.routes.draw do
    # For admin interface
  root to: 'admin#show'
  get '/index', to: 'admin#index'
  get '/show', to: 'admin#show'
  get '/new', to: 'admin#new'
  post '/admin', to: 'admin#create'
  get '/edit', to: 'admin#edit'
  patch '/admin', to: 'admin#update'
  get '/destroy', to: 'admin#destroy'
end
