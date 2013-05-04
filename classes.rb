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
            puts "from inside"
            x_array = @int_curve.map{ |x,y| x.to_f}
            #puts x_array
            #initialize loop
            low_p = 0.0
            high_p = 0.0
            puts "checking array"
            puts "#{c} --> #{low_p}"
            #while high_p <= c
                x_array.each_with_index do |element,index|
                    puts "Is #{c} <= #{element}"
                    #check if the evaluation point is in a range
                    if c < element
                        #Question:  How to make this stop the first time this happens?
                        puts "C is less than #{element}"
                        b = index
                        puts "#{b}"
                    elsif c > element
                        puts "C is in the range"
                        a = index - 1
                        puts "#{a}"
                    end
                
                end
            #end
            puts "Evaluate using: #{a} - #{b}"
            (@int_curve[b][1].to_f-@int_curve[a][1].to_f)/(@int_curve[b][0].to_f-@int_curve[a][0].to_f)*(c - @int_curve[a][0].to_f) + @int_curve[a][1].to_f
        else
            puts "This is not a number!"
            puts c.class
        end
    end
    
end

profit = Curve.new("profit")
puts profit.name
profit.create_curve("curve_profit.txt")
puts "Check the Method"
puts profit.payout(2.0,3.0,25.0)