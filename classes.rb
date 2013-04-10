#!/usr/bin/ruby -w

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
        #@int_curve.each { |x, y| puts "#{x} - #{y}\n"}
    end
    
    #This calulates the payout % between two points
    def payout(a,b,c)
        if c.is_a? Float #Fixnum
            #puts "Payout between points #{a} and #{b} at the value #{c} is..."
            #payout =
            (@int_curve[b][1].to_f-@int_curve[a][1].to_f)/(@int_curve[b][0].to_f-@int_curve[a][0].to_f)*(c - @int_curve[a][0].to_f) + @int_curve[a][1].to_f
        else
            puts "This is not a number!"
            puts c.class
        end
    end
    
end


#profit = Curve.new("profit")
#puts profit.name
#profit.create_curve("curve_profit.txt")
#puts "Calculate payout"
#puts profit.int_curve[1][1]
#puts profit.payout(2,3,25)
#puts "testing"
#puts profit.payout(2,3,"test")