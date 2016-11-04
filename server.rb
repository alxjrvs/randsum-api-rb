require 'sinatra'
require 'randsum'
require 'json'

get '/' do
  return "/roll/1/d/20, or just /roll."
end

get '/roll' do
  content_type :json
  serialize Randsum::D20.roll
end

get '/roll/:num/d/:sides' do
  content_type :json
  return 404 if bad params
  serialize roll_result
end

error 404 do
  'Bad parameters'
end

def roll_result
  die = Randsum::Die.new(sides_of_die)
  die.roll(number_of_dice)
end

def sides_of_die
  params[:sides].to_i
end

def number_of_dice
  params[:num].to_i
end

def bad(params)
  return true if params[:sides].to_i == 0
  return true if params[:num].to_i == 0
  return false
end

def serialize(result)
  {
    total:          result.total,
    rolls:          result.rolls,
    number_of_dice:  result.number_of_dice,
    die_sides:      result.die_sides
  }.to_json
end
