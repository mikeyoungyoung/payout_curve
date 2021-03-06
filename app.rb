require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'padrino-helpers'
require 'haml'
require 'json'
require_relative 'classes'
include FileUtils::Verbose

# We set the cache control for static resources to approximately 1 month
set :static_cache_control, [:public, :max_age => 2678400]

#GZip all files for speed
use Rack::Deflater

set :haml, :format => :html5

#Create curve objects
curves = Hash.new
curve_name = Hash.new
#for each file in curves director
Dir.chdir("./public/curves") do
    files = Dir.glob("*.txt")
    files.each do |file|
        filename = file.to_s
        object = Curve.new(filename)
        object.create_curve(filename)
        curves[file] = object
        curve_name[file] = file
    end
end

#class WebApp < Sinatra::Base

before do
    @flash = session.delete(:flash)
end

register Padrino::Helpers
get '/' do
    @c_name_test = params[:curves]
    @point = params[:message]
    @curves = curves
    @val_pts = Hash.new

    haml :index
end

post '/' do
    @c_name_test = params[:curves]
    @point = params[:message].to_f.round(2)
    @curves = curves
    #hash to store all payout per curve
    @val_pts = Hash.new
    #fit hash with evaluation result for each curve
    @curves.each_pair do |k,v|
        @val_pts[k] = v.payout(@point).round(2)
    end

    haml :index
end

get '/curves' do
    @curves = curves
    @curves.each {|k,v| puts v }
    @curve_name = curve_name
    @this = @curves[1]
    
    haml :curves
end

get '/tiles' do
    @curves = curves
    @sym = @curves.keys[0]

    haml :tiles
end

post '/tiles' do
    @curves = curves
    @sym = params[:display_curve]
    #in case no value is selected choose default
    @sym = @curves.keys[0] if params[:display_curve].empty?
    puts "^^^^^^^^^^^^"
    puts @sym
    puts "%%%%%%%%%%%%"
    
    haml :tiles
end

get '/contact' do
    
    haml :contact
end

get '/admin' do
    protected!
    @curves = curves
    #set @sym for first loading
    @sym = @curves.keys[0].to_sym
    #map to the view
    
    haml :admin
end

#do I need this piece?
get '/admin/upload' do
    #upload the file to the server location
    protected!
    haml :admin
end

post '/admin/upload' do
    
    if params[:file]
        filename = params[:file][:filename]
        file = params[:file][:tempfile]
        directory = "./public/curves"
        File.open(File.join(directory, filename), 'wb') do |f|
            f.write file.read
        #repeat curve creation from above down here
        #Dir.chdir("./public/curves") do
        #    files = Dir.glob("*.txt")
        #    files.each do |file|
        #       filename = file.to_s
        #        object = Curve.new(filename)
        #        object.create_curve(filename)
        #        curves[file] = object
        #    end
        #end
        end
        flash 'Upload successful'
    else
        flash 'You have to choose a file'
    end
    
    redirect '/admin'
end

delete '/admin/delete' do
    
    if params[:file]
        #filename = params[:file][:filename]
        filename = params[:file]

        directory = "./public/curves"
        puts filename
        puts File.join(directory, filename)
        #File.delete(File.join(directory, filename), 'wb')
        #need to delete the object here as well
        flash 'Upload successful'
        else
        flash 'You have to choose a file'
    end
    
    redirect '/admin'
end

__END__