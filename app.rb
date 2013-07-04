require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'chartkick'
require 'json'
require_relative 'classes'

# We set the cache control for static resources to approximately 1 month
set :static_cache_control, [:public, :max_age => 2678400]

#GZip all files for speed
use Rack::Deflater

set :haml, :format => :html5

#Create curve objects
profit = Curve.new("profit")
profit.create_curve("curve_profit.txt")
revenue = Curve.new("revenue")
revenue.create_curve("revenue.txt")
revenue.print_curve
utilization = Curve.new("utilization.txt")
utilization.create_curve("utilization.txt")
utilization.print_curve

#create hash of objects to pass curves
curves = Hash.new
curves[:profit] = profit
curves[:revenue] = revenue
curves[:utilization] = utilization

#class WebApp < Sinatra::Base

get '/' do
    @title = profit.name
    @curve_name = profit.filename
    @curve = profit.int_data
    @c_name_test = params[:curves]
    @point = params[:message]
    @curves = curves
    @curves.each {|k,v| puts v.int_data}
    #map to the view
    haml :index
end

post '/' do
    @title = profit.name
    @curve_name = profit.filename
    @curve = profit.int_data
    @c_name_test = params[:curves]
    @point = params[:message]
    puts params[:curves]
    if params[:message].nil?
        @pay = 0.0
    else
        @pay = profit.payout(params[:message].to_f)
    end
    @curves = curves
    puts @curves
    haml :index
end

get '/results' do
    params[:this] = profit.payout(10)
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