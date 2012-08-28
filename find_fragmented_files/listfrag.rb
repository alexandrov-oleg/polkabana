#!/usr/bin/env ruby

require "getoptlong"

# returns nuber of extents of the file
#
def get_extents file_name
	begin
	`filefrag "#{file_name}"`.scan(/\d+/).last.to_i
	rescue => e
	puts e.inspect
	puts "file: " + file_name
	1
	end
end

def human2bytes human_read_size
	eval human_read_size.gsub(/[KMG]/, "K" => "*1024", "M" => "*1048576", "G" => "*1073741824")
end

opts = GetoptLong.new(
	[ "--help", "-h", GetoptLong::NO_ARGUMENT ],
	[ "--size", "-s", GetoptLong::REQUIRED_ARGUMENT ],
	[ "--extents", "-e", GetoptLong::REQUIRED_ARGUMENT ]
)

filter_size = 0
filter_extents = 0

opts.each do |opt, arg|
	case opt
		when "--size"
		filter_size = human2bytes arg
		when "--extents"
		filter_extents = arg.to_i
		when '--help'
		puts <<-EOF

listfrag - recursively lists all files in current directory sorted by number of extents. Uses filefrag.

-h, --help
   show help

-s, --size x
   skip files that are smaller than x bytes. Can be in human readable format (e.g. 10M, 2G)

-e, --extents x
   skip files that have less than x extents

Example

   listfrag.rb -s 1G -e 10
   List all files recursively in current directory with file size >= 1G and number of extents >= 10

EOF
		exit
	end
end

files = []
Dir.glob("**/*") do |file_name|
	next if File.directory? file_name
	
	next if (file_size = File.size(file_name)) < filter_size
	next if (file_extents = get_extents(file_name)) < filter_extents
	
	files << {:name => file_name, :extents => file_extents,	:size => file_size}
end

puts "extents\tsize\tfile"
files.sort {|a1,a2| a2[:extents] <=> a1[:extents]}.each do |f|
	puts f[:extents].to_s + "\t" + f[:size].to_s + "\t" + f[:name]
end
