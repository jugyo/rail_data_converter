#!/usr/bin/env ruby

require 'rexml/parsers/streamparser'
require 'rexml/parsers/baseparser'
require 'rexml/streamlistener' 
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
  RailLoadSection.delete_all
  RailStation.delete_all
  RailCurve.delete_all
  RailPoint.delete_all
end

class MyListener
  include REXML::StreamListener
  
  def initialize
    super
    @point_data = {}
    @last_tag = nil
    @last_attrs = nil
  end
  
  def tag_start(name, attrs)
    # @rail_data は RailLoadSection か RailStation
    case name
    when 'ksj:EB02'
      @rail_data = RailLoadSection.new
      @rail_data.section_id = attrs['id']
    when 'ksj:EB03'
      @rail_data = RailStation.new
      @rail_data.station_id = attrs['id']
    when 'jps:GM_Point'
      @rail_point = RailPoint.new
      @rail_point.point_id = attrs['id']
    when 'jps:GM_Curve'
      @rail_curve = RailCurve.new
      @rail_curve.curve_id = attrs['id']
    when 'ksj:LOC'
      @rail_data.curve_id = attrs['idref']
    when 'ksj:SRS'
      @rail_data.rail_load_section_id = attrs['idref']
    when 'GM_PointRef.point'
      @rail_curve.points << attrs['idref']
    end
    @last_tag = name
    @last_attrs = attrs
  end
  
  def text(text)
    case @last_tag
      when 'DirectPosition.coordinate'
        coordinate = text.split
        lat = coordinate[0].to_f
        lng = coordinate[1].to_f
        if @rail_point
          @rail_point.lat = lat
          @rail_point.lng = lng
        elsif @rail_curve
          @rail_curve.points << {:lat => lat, :lng => lng}
        end
      when 'ksj:RAC'
        @rail_data.rail_way_class = text
      when 'ksj:INT'
        @rail_data.institution_type = text
      when 'ksj:LIN'
        @rail_data.line_name = text
      when 'ksj:OPC'
        @rail_data.operation_company = text
      when 'ksj:STN'
        @rail_data.station_name = text
    end
  end
  
  def tag_end(name)
    case name
      when /ksj:EB02|ksj:EB03/
        @rail_data.save
        p @rail_data
        @rail_data = nil
      when 'jps:GM_Point'
        @rail_point.save
        p @rail_point
        @rail_point = nil
      when 'jps:GM_Curve'
        @rail_curve.save
        p @rail_curve
        @rail_curve = nil
    end
    @last_tag = nil
    @last_attrs = nil
  end
end

def convert(file_name)
  open(file_name) do |file|
    listener = MyListener.new
    REXML::Parsers::StreamParser.new(file, listener).parse
  end
end

unless ARGV.size == 1
  puts 'Usage: ./convert.rb <xml_file_name>'
  exit
end

init_for_active_record

result = Benchmark.measure {
  convert(ARGV[0])
}

puts '-------------------------------------------------'
puts Benchmark::CAPTION
puts result
