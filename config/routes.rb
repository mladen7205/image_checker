Rails.application.routes.draw do
  get 'answers(/*url)', to: 'answers#answer'
  get 'api/docs'
  
  get "up" => "rails/health#show", as: :rails_health_check
end