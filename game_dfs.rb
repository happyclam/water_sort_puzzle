require "./node.rb"

def dfs(node, box, depth)
  result = nil
  if depth < 0
    return result
  else
    if box.check
      p "depth = #{depth}"
      p "Complete!!"
      return box
    end
  end
  box.bottles.each_with_index{|bottle, i|
    emptyBottleFlg = false
    box.bottles.each_with_index{|dest, j|
      next if j == i
      next if dest.size >= MAX_UNIT
      next if bottle.size <= 0
      next if bottle.check
      next if emptyBottleFlg
      if (dest.empty?)
        emptyBottleFlg = true
      end
      next if bottle.monoCheck && dest.empty?
      next unless (bottle.last == dest.last) || (dest.empty?)
      temp = box.deepCopy
      temp.bottles[i].pour(temp.bottles[j])
      md5hash = Node.make_hash(temp.dup)
      if Node.check_dup(md5hash)
        next
      else
        Node.set_dup(md5hash)
      end
      # DFSの場合はaddではなくreplace（置き換え）でいいはず、addでも結果は得られるけど…。
      ret = node.replace(Node.new(temp), box)
      unless ret
        p "Error"
        exit
      end
      result = dfs(node, temp, depth - 1)
      break if result.class.name == "Box"
    }
    break if result.class.name == "Box"
  }
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
# 手数: 46手
# 経過時間: 0.01530837秒

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
# "解無し？あるいは読む深さが足りません"

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
# 手数: 33手
# 経過時間: 0.302961094秒

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
# 手数: 29手
# 経過時間: 0.00499378秒

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
# 手数: 21手
# 経過時間: 0.004331723秒

box = Box.new(
  [
    Bottle.new([ORANGE, RED, ORANGE, RED]),
    Bottle.new([BLUE, BLUE, ORANGE, RED]),
    Bottle.new([RED, ORANGE, BLUE, BLUE]),
    Bottle.new,
    Bottle.new
  ]
)
# 手数: 13手
# 経過時間: 0.001156548秒

Node.init
box.display
node = Node.new(box)
start = Time.now
answer = dfs(node, box, 100)
if answer.class.name == "Box"
  node.search(answer)
  endtime = Time.now
  puts "-" * answer.bottles.length
  puts "手数: #{Node.counter}手"
  puts "経過時間: #{(endtime - start)}秒"
else
  p "解無し？あるいは読む深さが足りません"
end
