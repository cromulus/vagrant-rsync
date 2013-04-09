# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard :shell,:all_on_start => true  do
  watch /.*/ do |m|
    `vagrant rsync` 
   puts `pwd`
  end 
end
