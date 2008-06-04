require 'yaml'
class RailCurve < ActiveRecord::Base
  
  attr_writer :points
  
  def initialize
    super
  end
  
  def points
    @points = self.curve ? YAML::load(self.curve) : [] unless @points
    @points
  end
  
  def save
    self.curve = @points.to_yaml if @points
    super
  end
end
