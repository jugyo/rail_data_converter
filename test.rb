require 'rubygems'
require 'active_record'
require 'models/rail_load_section'
require 'models/rail_station'
require 'models/rail_curve'
require 'models/rail_point'

def init_for_active_record
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'db/rail_data.sqlite3'
  )
end

init_for_active_record

#~ c = RailCurve.find(:first)
#~ p eval(c.curve)

point = RailPoint.find_by_point_id('pt20743_rr')
p point
