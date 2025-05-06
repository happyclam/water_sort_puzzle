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
          break
        end
        queue.push(temp.dup)
      }
      break if result.class.name == "Box"
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
# 手数: 36手
# 経過時間: 279.599430481秒

# 手詰まりパターン
# box = Box.new(
#   [
#     Bottle.new([SKY_BLUE, SKY_BLUE, SKY_BLUE]),
#     Bottle.new,
#     Bottle.new([BLUE, ORANGE, PINK, RED]),
#     Bottle.new([ORANGE, BLUE, ORANGE, ORANGE]),
#     Bottle.new([YELLOW_GREEN, PURPLE, MAGENTA, RED]),
#     Bottle.new([AQUA_GREEN, MAGENTA, PINK, PINK]),
#     Bottle.new([PURPLE, PURPLE]),
#     Bottle.new([PINK, SKY_BLUE, YELLOW, YELLOW]),
#     Bottle.new([YELLOW, MAGENTA, RED, GRAY]),
#     Bottle.new([MAGENTA, GRAY, YELLOW_GREEN, YELLOW_GREEN]),
#     Bottle.new([RED, PURPLE, BLUE, YELLOW]),
#     Bottle.new([GRAY, GRAY, YELLOW_GREEN, BLUE]),
#     Bottle.new([DARK_GREEN, DARK_GREEN, DARK_GREEN, DARK_GREEN]),
#     Bottle.new([AQUA_GREEN, AQUA_GREEN, AQUA_GREEN])
#   ]
# )
# "解無し？"

# 途中から完成パターン
# box = Box.new(
#   [
#     Bottle.new,
#     Bottle.new([MAGENTA, MAGENTA, YELLOW, YELLOW_GREEN]),
#     Bottle.new([BLUE, PINK, DARK_GREEN]),
#     Bottle.new([PURPLE, DARK_GREEN, PINK, PINK]),
#     Bottle.new([YELLOW_GREEN, RED, RED, RED]),
#     Bottle.new([PURPLE, DARK_GREEN, GRAY, GRAY]),
#     Bottle.new([MAGENTA, PURPLE, BLUE, GRAY]),
#     Bottle.new([GRAY, RED, PINK]),
#     Bottle.new([MAGENTA, BLUE, BLUE, YELLOW_GREEN]),
#     Bottle.new([PURPLE, SKY_BLUE, YELLOW_GREEN, DARK_GREEN]),
#     Bottle.new([YELLOW, YELLOW, YELLOW]),
#     Bottle.new([SKY_BLUE, SKY_BLUE, SKY_BLUE])
#   ]
# )
# 手数: 25手
# 経過時間: 1.547255429秒

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
# )
# 手数: 22手
# 経過時間: 8.723311114秒

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
# )
# 手数: 15手
# 経過時間: 0.33458553秒

box = Box.new(
  [
    Bottle.new([ORANGE, RED, ORANGE, RED]),
    Bottle.new([BLUE, BLUE, ORANGE, RED]),
    Bottle.new([RED, ORANGE, BLUE, BLUE]),
    Bottle.new,
    Bottle.new
  ]
)
# 手数: 8手
# 経過時間: 0.01411219秒

Node.init
box.display
node = Node.new(box)
start = Time.now
answer = bfs(node)
if answer.class.name == "Box"
  node.search(answer)
  endtime = Time.now
  puts "-" * answer.bottles.length
  puts "手数: #{Node.counter}手"
  puts "経過時間: #{(endtime - start)}秒"
else
  p "解無し？"
end
