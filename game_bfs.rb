require "./node.rb"

def bfs(node)
  result = nil
  queue = Array.new
  queue.push(node.value.dup)
  cnt = 0
  while queue != [] do
    box = queue.shift
    box.bottles.each_with_index{|bottle, i|
      emptyBottleFlg = false
      box.bottles.each_with_index{|dest, j|
        next if j == i
        next if dest.size >= MAX_UNIT
        next if bottle.size <= 0
        # 一色に揃っていて満タンのボトル（完成）は動かさない
        next if bottle.check
        # 空のボトルを２回試行しないように
        next if emptyBottleFlg
        if (dest.empty?)
          emptyBottleFlg = true
        end
        # 満タンではないけど一色に揃ってるボトルを空のボトルに注ぐ無駄を省く
        next if bottle.monoCheck && dest.empty?
        next unless (bottle.last == dest.last) || (dest.empty?)
        cnt += 1
        temp = box.deepCopy
        temp.bottles[i].pour(temp.bottles[j])
        # temp.display
        md5hash = Node.make_hash(temp.dup)
        if Node.check_dup(md5hash)
          next
        else
          Node.set_dup(md5hash)
        end
        ret = node.add(Node.new(temp), box)
        unless ret
          p "Error"
          p "cnt = #{cnt}"
          p "temp = #{temp.bottles}"
          exit
        end
        if temp.check
          p "cnt = #{cnt}"
          p "Complete!!"
          result = temp
          # return temp
        end
        queue.push(temp.dup)
      }
    }
    break if result.class.name == "Box"
  end
  return result
end

# 答えが知りたかったケース
# box = Box.new(
#   [
#       Bottle.new([RED, SKY_BLUE, RED, YELLOW]),
#       Bottle.new([MAGENTA, PINK, AQUA_GREEN, RED]),
#       Bottle.new([AQUA_GREEN, YELLOW_GREEN, PURPLE, BLUE]),
#       Bottle.new([SKY_BLUE, MAGENTA, ORANGE, YELLOW]),
#       Bottle.new([PURPLE, PINK, ORANGE, YELLOW_GREEN]),
#       Bottle.new([PURPLE, BLUE, PINK, AQUA_GREEN]),
#       Bottle.new([ORANGE, YELLOW, AQUA_GREEN, PURPLE]),
#       Bottle.new([SKY_BLUE, BLUE, GRAY, GRAY]),
#       Bottle.new([SKY_BLUE, YELLOW_GREEN, MAGENTA, RED]),
#       Bottle.new([YELLOW, MAGENTA, ORANGE, GRAY]),
#       Bottle.new([YELLOW_GREEN, GRAY, PINK, BLUE]),
#       Bottle.new,
#       Bottle.new
#   ]
# )
# 経過時間: ???
# box = Box.new(
#   [
#       Bottle.new([RED, PURPLE, RED, MAGENTA]),
#       Bottle.new([RED, YELLOW, DARK_GREEN, YELLOW]),
#       Bottle.new([MAGENTA, YELLOW_GREEN, RED, BLUE]),
#       Bottle.new([PINK, PURPLE, BLUE, DARK_GREEN]),
#       Bottle.new([MAGENTA, SKY_BLUE, YELLOW_GREEN, BLUE]),
#       Bottle.new([PURPLE, SKY_BLUE, PURPLE, SKY_BLUE]),
#       Bottle.new([PINK, GRAY, DARK_GREEN, YELLOW_GREEN]),
#       Bottle.new([PINK, PINK, YELLOW, GRAY]),
#       Bottle.new([MAGENTA, SKY_BLUE, GRAY, GRAY]),
#       Bottle.new([DARK_GREEN, YELLOW_GREEN, YELLOW, BLUE]),
#       Bottle.new,
#       Bottle.new
#   ]
# )
# box = Box.new(
#   [
#     Bottle.new([BLUE, YELLOW_GREEN, RED, YELLOW_GREEN]),
#     Bottle.new([YELLOW, ORANGE, ORANGE, ORANGE]),
#     Bottle.new([RED, YELLOW, YELLOW_GREEN, ORANGE]),
#     Bottle.new([YELLOW_GREEN, RED, YELLOW, RED]),
#     Bottle.new([BLUE, BLUE, BLUE, YELLOW]),
#     Bottle.new,
#     Bottle.new
#   ]
#  )
# box = Box.new(
#   [
#     Bottle.new([ORANGE, YELLOW_GREEN, YELLOW, BLUE]),
#     Bottle.new([ORANGE, RED, YELLOW, RED]),
#     Bottle.new([BLUE, BLUE, YELLOW, RED]),
#     Bottle.new([YELLOW_GREEN, YELLOW_GREEN, BLUE, RED]),
#     Bottle.new([ORANGE, YELLOW, ORANGE, YELLOW_GREEN]),
#     Bottle.new,
#     Bottle.new
#   ]
#  )
# box = Box.new(
#   [
#     Bottle.new([PINK, YELLOW_GREEN, GRAY, PINK]),
#     Bottle.new([BLUE, YELLOW_GREEN, ORANGE, YELLOW]),
#     Bottle.new([ORANGE, YELLOW, BLUE, PINK]),
#     Bottle.new([RED, ORANGE, ORANGE, PINK]),
#     Bottle.new([GRAY, YELLOW, BLUE, RED]),
#     Bottle.new([YELLOW_GREEN, RED, BLUE, GRAY]),
#     Bottle.new([YELLOW_GREEN, GRAY, RED, YELLOW]),
#     Bottle.new,
#     Bottle.new
#   ]
#  )
# 経過時間: 13042.383219747秒
# box = Box.new(
#   [
#     Bottle.new([YELLOW, YELLOW, RED, BLUE]),
#     Bottle.new([BLUE, ORANGE, ORANGE, RED]),
#     Bottle.new([YELLOW_GREEN, BLUE, YELLOW, YELLOW_GREEN]),
#     Bottle.new([YELLOW_GREEN, BLUE, YELLOW_GREEN, RED]),
#     Bottle.new([RED, ORANGE, YELLOW, ORANGE]),
#     Bottle.new,
#     Bottle.new
#   ]
#  )
# box = Box.new(
#   [
#     Bottle.new([ORANGE, RED, YELLOW_GREEN, BLUE]),
#     Bottle.new([RED, YELLOW, YELLOW, BLUE]),
#     Bottle.new([YELLOW_GREEN, ORANGE, YELLOW, RED]),
#     Bottle.new([BLUE, BLUE, ORANGE, YELLOW]),
#     Bottle.new([RED, YELLOW_GREEN, ORANGE, YELLOW_GREEN]),
#     Bottle.new,
#     Bottle.new
#   ]
#  )
# box = Box.new(
#   [
#     Bottle.new([GRAY, PURPLE, DARK_GREEN, ORANGE]),
#     Bottle.new([BLUE, YELLOW_GREEN, DARK_GREEN, BLUE]),
#     Bottle.new([SKY_BLUE, PINK, GRAY, SKY_BLUE]),
#     Bottle.new([BLUE, PURPLE, PINK, PINK]),
#     Bottle.new([DARK_GREEN, BLUE, YELLOW, PINK]),
#     Bottle.new([MAGENTA, ORANGE, SKY_BLUE, MAGENTA]),
#     Bottle.new([YELLOW_GREEN, PURPLE, MAGENTA, ORANGE]),
#     Bottle.new([MAGENTA, YELLOW, PURPLE, YELLOW_GREEN]),
#     Bottle.new([GRAY, DARK_GREEN, YELLOW, YELLOW_GREEN]),
#     Bottle.new([GRAY, ORANGE, SKY_BLUE, YELLOW]),
#     Bottle.new,
#     Bottle.new
#   ]
# )
box = Box.new(
  [
    Bottle.new([ORANGE, RED, ORANGE, RED]),
    Bottle.new([BLUE, BLUE, ORANGE, RED]),
    Bottle.new([RED, ORANGE, BLUE, BLUE]),
    Bottle.new,
    Bottle.new
  ]
)

box.display
node = Node.new(box)
start = Time.now
answer = bfs(node)
if answer.class.name == "Box"
  node.search(answer)
  endtime = Time.now
  puts "-" * answer.bottles.length
  puts "経過時間: #{(endtime - start)}秒"
else
  p "解無し？"
end
