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

#^^^^^^^^^^^^^^^^
#Note:  Maybe here I can read a .txt files in a directory and create the curves

#Create curve objects
profit = Curve.new("Profitability")
profit.create_curve("curve_profit.txt")
revenue = Curve.new("Revenue 1")
revenue.create_curve("revenue.txt")
revenue_2 = Curve.new("Revenue 2")
revenue_2.create_curve("revenue_2.txt")
ae_2013 = Curve.new("AE 2013")
ae_2013.create_curve("ae_2013.txt")
SSRS = Curve.new("SSRS")
SSRS.create_curve("SSRS.txt")
SWRev_Uncapped = Curve.new("Software Revenue: Uncapped")
SWRev_Uncapped.create_curve("swrev_uncapped.txt")
Quan_NonFinancial = Curve.new("Quantitative Non-Financial")
Quan_NonFinancial.create_curve("quan_non-financial.txt")

#create hash of objects to pass curves
curves = Hash.new
curves[:profit] = profit
curves[:revenue] = revenue
curves[:ae_2013] = ae_2013
curves[:revenue_2] = revenue_2
curves[:SSRS] = SSRS
curves[:SWRev_Uncapped] = SWRev_Uncapped
curves[:Quan_NonFinancial] = Quan_NonFinancial

#class WebApp < Sinatra::Base

get '/' do
    @title = profit.name
    @curve_name = profit.filename
    @curve = profit.int_data
    @c_name_test = params[:curves]
    @point = params[:message]
    @curves = curves
    @val_pts = Hash.new
    #map to the view
    haml :index
end

post '/' do
    @c_name_test = params[:curves]
    @point = params[:message].to_f
    @curves = curves
    #hash to store all payout per curve
    @val_pts = Hash.new
    #check if evaluation point <=0, set to near zero if true
    @point = @point <= 0 ? 0.0001 : @point

    @curves.each_pair do |k,v|
        @val_pts[k] = v.payout(@point).round(2)
    end

    haml :index
end

get '/results' do
    params[:this] = profit.payout(10)
    haml :results
end

get '/contact' do
    @curves = curves
    haml :contact
end

get '/tiles' do
    @title = profit.name
    @curve_name = profit.filename
    @curve = profit.int_data
    @c_name_test = params[:curves]
    @point = params[:message]
    @curves = curves
    @val_pts = Hash.new
    #set @sym for first loading
    @sym = "profit".to_sym
    #map to the view
    haml :tiles
end

post '/tiles' do
    @sym = params[:display_curve].to_sym
    #in case no value is selected choose default
    @sym = "profit".to_sym if params[:display_curve].empty?
    @curves = curves

    haml :tiles
end

__END__