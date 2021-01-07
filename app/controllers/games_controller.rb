require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = (1..10).map { ('a'..'z').to_a.sample }
  end

  def score
    @answer = params[:word]
    @letters = params[:letters]
    @result = ''
    if !inside_grid?(@answer, @letters)
      @result = "Sorry, but #{@answer.upcase} can’t be built out of #{@letters}."
    elsif !english_word?(@answer)
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    elsif inside_grid?(@answer, @letters)
      @result = "Congratulation! #{@answer.upcase} is a valid English word."
    end
  end


  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def inside_grid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def result(word)
    word.length**2
  end

end
