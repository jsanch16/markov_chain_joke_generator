class MarkovJokesController < ApplicationController
  def generate_joke
    # cached_jokes = get_cached_jokes(params[:search_term])
    response = HTTParty.get(
      'https://icanhazdadjoke.com/search',
      headers: { "Accept" => "application/json"},
      query: { term: params[:search_term] }
    )
    jokes = response['results'].pluck("joke").join(" ")
    generated_joke = MarkovChainGenerate.call(jokes)
    if generated_joke.success?
      render json: { joke: generated_joke.result }
    else
      render json: { error: generated_joke.errors }, status: :unprocessable_entity
    end
  end
end
