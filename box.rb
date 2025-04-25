require "./const.rb"
require "./bottle.rb"
class Box
  @@colors = {YELLOW => "黃色", RED => "赤色" , SKY_BLUE => "水色", AQUA_GREEN => "薄緑", PINK => "桃色", MAGENTA => "赤紫", BLUE => "青色", PURPLE => "紫色", YELLOW_GREEN => "黄緑", ORANGE => "橙色", GRAY => "灰色", DARK_GREEN => "深緑"}
  def self.colors
    @@colors
  end
  attr_accessor :bottles
  def initialize(bottles)
    @bottles = bottles.dup
    @bottles.each_with_index{|b, i|
      b.name = i.to_s
    }
  end
  def deepCopy
    # member = @bottles.map(&:dup)
    member = []
    @bottles.each{|b|
      member.push(Bottle.new(b))
    }
    temp = Box.new(member)
    temp.bottles.each_with_index{|t, i|
      t.name = @bottles[i].name
      t.complete = @bottles[i].complete
    }
    return temp
  end
  def check
    @bottles.each{|b|
      return false if b.check == false
    }
    return true
  end
  def display
    lines = ["", "", "", ""]
    @bottles.each{|b|
      color = b[3] ? @@colors[b[3]] : "　　"
      lines[0] += "|" + color
      color = b[2] ? @@colors[b[2]] : "　　"
      lines[1] += "|" + color
      color = b[1] ? @@colors[b[1]] : "　　"
      lines[2] += "|" + color
      color = b[0] ? @@colors[b[0]] : "　　"
      lines[3] += "|" + color
    }
    p "-" * @bottles.length
    lines.each{|l|
      p l + "|"
    }
  end
end
