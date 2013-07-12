#!/usr/bin/ruby -w
# Global Variables
$tol = 0.0001

hash_to_table = Proc.new { |k,v| "<tr><td>#{k}</td><td>#{v}</td></tr>"}

#test_hash ={1=>1, 2=>2, 3=>3}
#rows = test_hash.collect.each(&hash_to_table)
#puts rows

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
            
            #Reset the evaluation point if it breaches the upper limit of the curve
            c = c >= @x_arr.last.to_f ? @x_arr.last.to_f - $tol : c
            
            #get low array and low point
            low_arr = @int_curve.select {|x,y| x.to_f < c }
            low_p = low_arr.last
            #get high array and high point
            high_arr = @int_curve.select {|x,y| x.to_f >= c }
            #high_p = c >= high_arr.first ? high_arr.first[0] - eps : high_arr.first
            high_p = high_arr.first
            #Evaluate equation of line in two point form
            return (high_p[1].to_f-low_p[1].to_f)/(high_p[0].to_f-low_p[0].to_f)*(c - low_p[0].to_f) + low_p[1].to_f
        else
            return "This is not a number!"
        end
    end
    
end
