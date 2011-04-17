def usage()
     puts "topN.rb <n> <day> <max_day_score>"
end

if ARGV.length < 3
     usage
     exit
end

n = Integer(ARGV[0])
field = Integer(ARGV[1])
max = Integer(ARGV[2])

scores = []
$stdin.each { |line|
     array = line.strip.split(",")
     if array[field] != '--'
          scores.push(Integer(array[field]))
     else
          scores.push(max)
     end
}

scores = scores.sort

acc = 0
for i in 0...n do
     acc += scores[i]
end
puts acc
