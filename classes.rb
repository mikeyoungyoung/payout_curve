#!/usr/bin/ruby -w
# Global Variables
$tol = 0.0001

helpers do
    def flash(message = '')
        session[:flash] = message
    end

    def protected!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
    end

    def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'Welcome1']
    end
end

hash_to_table = Proc.new { |k,v| "<tr><td>#{k}</td><td>#{v}</td></tr>"}

class Curve
    attr_accessor :data, :name, :filename, :int_data, :int_curve
    def initialize(name)
        @name = name
        #  @data = array
    end

    #methods
    #Create the curve from a file
    def create_curve(filename)
        @filename = filename
        @int_data = {}
        File.open(@filename, 'r').each_line do |line|
            line = line.strip.split ' '
            @int_data[line.first.to_s] = line.last.to_s
        end
        @int_curve = @int_data.to_a
        @x_arr = int_curve.map {|x,y| x}
        @y_arr = int_curve.map {|x,y| y}
    end
    #method to print the curve
    def print_curve
        @int_data.each {|x,y| puts "#{x} -> #{y} "}
    end
    
    #This calulates the payout % between two points
    def payout(c)
        if c.is_a? Float #Fixnum
            #check to see if the number is in the allowed range
            #What if it is higher than the top point?
            if c >= @x_arr.last.to_f
                c = @x_arr.last.to_f - $tol
            elsif c <= @x_arr.first.to_f
                c = @x_arr.first.to_f + $tol
            end
            #What if it is lower than the bottom point
            #Reset the evaluation point if it breaches the upper limit of the curve
            #c = c >= @x_arr.last.to_f ? @x_arr.last.to_f - $tol : c
            #get low array and low point
            low_arr = @int_curve.select {|x,y| x.to_f < c }
            low_p = low_arr.last
            #get high array and high point
            high_arr = @int_curve.select {|x,y| x.to_f >= c }
            high_p = high_arr.first
            #Evaluate equation of line in two point form
            return (high_p[1].to_f-low_p[1].to_f)/(high_p[0].to_f-low_p[0].to_f)*(c - low_p[0].to_f) + low_p[1].to_f
        else
            return "This is not a number!"
        end
    end
    
end
