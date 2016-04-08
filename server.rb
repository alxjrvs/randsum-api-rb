require 'sinatra'
require 'rollr'
require 'json'

get '/' do
  return "/roll/1/d/20, or just /roll."
end

get '/roll' do
  content_type :json

  result = Rollr::D20.roll
  serialize result
end

get '/roll/:num/d/:sides' do
  content_type :json

  if bad params
    404
  else
    sides = params[:sides].to_i
    num = params[:num].to_i

    die = Rollr::Die.new(sides.to_i)
    result = die.roll(number: num.to_i)
    
    serialize result
  end

end

error 404 do
  'Bad parameters'
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
    numer_of_dice:  result.number_of_dice,
    die_sides:      result.die_sides
  }.to_json
end
