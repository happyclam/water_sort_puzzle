require "digest"
require "./const.rb"
require "./bottle.rb"
require "./box.rb"

class Node
  @@counter = 0
  @@duplication = []
  attr_reader :value, :child
  def initialize(box)
    @value = box
    @child = []
  end
  def self.counter
    @@counter
  end
  def self.duplication
    @@duplication
  end
  def self.check_dup(hash)
    return @@duplication.include?(hash)
  end
  def self.set_dup(hash)
    @@duplication.push(hash)
  end
  def self.init
    @@counter = 0
    @@duplication.clear
  end
  def self.make_hash(box)
    rec = Array.new
    box.bottles.each{|b|
      rec.push(b)
    }
    md5 = Digest::MD5.new
    return md5.update(rec.sort_by{|r| r.name}.to_s).to_s
    # return rec.sort_by{|r| r.name}
  end
  def add(nd, target)
    ret = false
    if @value.bottles == target.bottles
      @child.push(nd)
      ret = true
    else
      @child.each_with_index {|c, i|
        if c.value.bottles == target.bottles
          c.child.push(nd)
          ret = true
        else
          ret = c.add(nd, target)
        end
        break if ret
      }
    end
    return ret
  end
  def replace(nd, target)
    ret = false
    if @value.bottles == target.bottles
      @child.clear
      @child.push(nd)
      ret = true
    else
      @child.each_with_index {|c, i|
        if c.value.bottles == target.bottles
          c.child.clear
          c.child.push(nd)
          ret = true
        else
          ret = c.add(nd, target)
        end
        break if ret
      }
    end
    return ret
  end
  def search(target)
    ret = false
    @child.each{|c|
      if c.value.bottles == target.bottles
        ret = true
        @@counter += 1
        p "counter = #{@@counter}"
        c.value.display
      else
        ret = c.search(target)
        if ret
          @@counter += 1
          p "counter = #{@@counter}"
          c.value.display
        end
      end
      break if ret
    }
    return ret
  end
end
