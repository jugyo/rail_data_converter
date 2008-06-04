task "default" => "dist"

task "test" => ["init_db"] do
  sh "./convert.rb test.xml"
  sh "./convert_curve_data.rb"
end

task "dist" => ["init_db"] do
  sh "./convert.rb rail_data.xml"
  sh "./convert_curve_data.rb"
end

task "init_db" do
  sh "rm -f db/rail_data.sqlite3"
  sh "sqlite3 db/rail_data.sqlite3 < db/schema.sql"
end

