Rails.application.routes.draw do
  get 'generate_joke', to: 'markov_jokes#generate_joke'
end
