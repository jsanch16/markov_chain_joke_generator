class MarkovJokesController < ApplicationController
  def generate_joke
    cache_key = ["joke_texts", params[:q]]
    cached_text = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      HTTParty.get(
        "https://icanhazdadjoke.com/search?limit=30&term=#{params[:q]}",
        headers: { "Accept" => "application/json"}
      )
    end
    if cached_text
      jokes = cached_text['results'].pluck("joke").join(" ")
      @generated_joke = MarkovChainGenerate.call(jokes)
      if @generated_joke.success?
        render template: "markov_jokes/show"
      else
        render plain: 'There was an error generating your joke. Please try '\
        'again.'
      end
    else
      render plain: 'There was an error retrieving jokes from the API. try '\
      "again later."
  end

  def new
    # @markov_joke = MarkovJoke.new
  end
end
