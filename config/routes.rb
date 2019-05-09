Rails.application.routes.draw do
  root 'markov_jokes#new'
  get 'generate_joke', to: 'markov_jokes#generate_joke'
end
