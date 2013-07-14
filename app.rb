require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'json'
require_relative 'classes'
include FileUtils::Verbose

#for global authentification
#use Rack::Auth::Basic, "Restricted Area" do |username, password|
#    username == 'admin' and password == 'admin'
#end

# We set the cache control for static resources to approximately 1 month
set :static_cache_control, [:public, :max_age => 2678400]

#GZip all files for speed
use Rack::Deflater

set :haml, :format => :html5

#^^^^^^^^^^^^^^^^
#Note:  Maybe here I can read a .txt files in a directory and create the curves

#Create curve objects
curves = Hash.new
#for each file in curves director
Dir.chdir("./public/curves") do
    files = Dir.glob("*.txt")
    puts "These files will be used:"
    puts files
    puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    #create curves for each file
    i = 0
    files.each do |file|
        puts "Creating: #{file}"
        filename = file.to_s
        object = Curve.new(filename)
        object.create_curve(filename)
        curves[file] = object
        curves.each_key {|k| puts "#{k}: iteration #{i}" }
        i += 1
    end
end
puts "List all curves"
curves.each_key {|k| puts curves[k].name}
puts Dir.pwd

#class WebApp < Sinatra::Base

before do
    @flash = session.delete(:flash)
end

get '/' do
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

    @curves = curves
    @sym = @curves.keys[0]
    #map to the view

    haml :tiles
end

post '/tiles' do
    @curves = curves
    @sym = params[:display_curve]
    #in case no value is selected choose default
    @sym = @curves.keys[0] if params[:display_curve].empty?
    
    haml :tiles
end

get '/admin' do
    protected!
    @curves = curves
    #set @sym for first loading
    @sym = @curves.keys[0].to_sym
    #map to the view
    
    haml :admin
end

get '/admin/upload' do
    #upload the file to the server location
    protected!
    haml :admin
end

post '/admin/upload' do
    #unless params[:file] &&
    #    (tmpfile = params[:file][:tempfile]) &&
    #    (name = params[:file][:filename])
    #    @error = "No file selected"
    #    return haml(:admin)
    #end
    #STDERR.puts "Uploading file, original name #{name.inspect}"
    #while blk = tmpfile.read(65536)
    #    # here you would write it to its final location
    #    directory = "./public/curves"
    #    path = File.join(directory, name)
    #    File.open(path, "wb") do |f|
    #        f.write(tmpfile.read)
    #        f.close
    #    end
    #
    #    STDERR.puts blk.inspect
    #end
    #"Upload complete"
    
    if params[:file]
        filename = params[:file][:filename]
        file = params[:file][:tempfile]
        directory = "./public/curves"
        File.open(File.join(directory, filename), 'wb') do |f|
            f.write file.read
        end
        
        flash 'Upload successful'
    else
        flash 'You have to choose a file'
    end
    
    redirect '/admin'
end



__END__