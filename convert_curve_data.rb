#!/usr/bin/env ruby

require 'rubygems'
require 'active_record'
require 'models/rail_load_section'
require 'models/rail_station'
require 'models/rail_curve'
require 'models/rail_point'
require 'benchmark'

def init_for_active_record
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'db/rail_data.sqlite3'
  )
end

def convert_curve_data
  RailCurve.find(:all).each do |row|
    puts "id: #{row.id}"
    puts "  #{row.points.inspect}"
    row.points.map! do |item|
      if item.class == String
        point = RailPoint.find_by_point_id(item)
        {:lat=>point.lat, :lng=>point.lng}
      else
        item
      end
    end
    row.save
    puts "    => #{row.points.inspect}"
  end
end

init_for_active_record

result = Benchmark.measure {
  convert_curve_data
}
puts '-------------------------------------------------'
puts Benchmark::CAPTION
puts result
