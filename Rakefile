
task :default => :all


task :all => [:package]


desc 'create addon zip'
task :package do
  src_path = 'addons/urakata'
  zip_path = 'tmp/addons.tar.gz'

  sh "COPYFILE_DISABLE=1 tar cfz #{zip_path} --exclude='.DS_Store' #{src_path}"
  puts "=> #{zip_path}"
end
