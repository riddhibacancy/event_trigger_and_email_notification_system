Rails.application.routes.draw do
  root to: "events#index"

  devise_for :users

  get 'events/event_a', to: 'events#event_a'
  get 'events/event_b', to: 'events#event_b'

  post 'events/event_a', to: 'events#event_a'
  post 'events/event_b', to: 'events#event_b'
end
