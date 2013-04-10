require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
#require 'data_mapper'
require 'shotgun'
#require 'dm-sqlite-adapter'
require_relative 'classes'

# We set the cache control for static resources to approximately 1 month
set :static_cache_control, [:public, :max_age => 2678400]

#GZip all files for speed
use Rack::Deflater

set :haml, :format => :html5

profit = Curve.new("profit")
#puts profit.name
profit.create_curve("curve_profit.txt")
#puts "Calculate payout"
#puts profit.int_curve[1][1]
#puts profit.payout(2,3,25)

#class WebApp < Sinatra::Base

get '/' do
    @title = profit.name
    @curve_name = profit.filename
    @c_name_test = params[:curves]
    @pay = profit.payout(2,3,25.0)
    @point = params[:message]
    #    puts "In get for /"
    #params.sort{|a,b| a[1]<=>b[1]}.each { |elem|
    #    puts "#{elem[1]}, #{elem[0]}"
    #}
    #puts params[:message]
    #puts "done"
    #puts @point
    #puts @point.class
    haml :index
end

post '/' do
    @title = profit.name
    #puts "In post for /"
    #params.sort{|a,b| a[1]<=>b[1]}.each { |elem|
    #    puts "#{elem[1]}, #{elem[0]}"
    #}
    #puts "#{params[:message]}"
    #puts "done"
    #puts @point.to_f
    @pay = profit.payout(1,2,params[:message].to_f)
    haml :index
    #params[:payout]
    #redirect '/results'
end

get '/results' do
    params[:this] = profit.payout(1,2,10)
    #    "This is the point: #{params[:message]}"
    #        "This is the point: #{params[:payout]}"
    haml :results
end

get '/contact' do
    haml :contact
end

get '/tiles' do
    haml :tiles
end

#end

__END__