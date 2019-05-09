class MarkovChainGenerate
  prepend SimpleCommand


  # {
  #   "word1": { 
  #     "next_word1": 2,
  #     "next_word2": 1
  #   }
  #   "word2":{
  #     "next_word1": 3,
  #     "next_word2": 1
  #   }
  # }
  def initialize(text)
    @text = text
    @word_frequencies = {}
    word_array = text.split(" ")
    #split and pass each two adjacent words to add
    word_array.each_cons(2) do |word, next_word|
      @word_frequencies[word] ||= Hash.new(0)
      @word_frequencies[word][next_word] += 1
    end
  end

  # construct a sentence
  # 1. Create a markov chain of word probabilities with API as data source
  # 2. Generate sequence of words based on their frequencies of their next
  #    word.
  # 3. Stop when sentence is created (A detection of a period)
  def call
    sentence = ""
    word = word_frequencies.keys.sample
    while sentence.count(".") == 0 do
      sentence += word.nil? ? "" : "#{word} "
      word = get_next_word(word)
    end
    sentence
  end


  private
  attr_accessor :text, :word_frequencies

  def get_next_word(word)
    return "" if !word_frequencies.key?(word)
    pot_next_words = word_frequencies[word]
    sum = pot_next_words.inject(0) {|sum,kv| sum += kv[1]}
    random = rand(sum)+1
    partial_sum = 0
    next_word = pot_next_words.find do |word, count|
      partial_sum += count
      partial_sum >= random
    end.first
    next_word
  end
end