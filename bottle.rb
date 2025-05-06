require "./const.rb"

class Bottle < Array
  def initialize(*args, &block)
    super(*args, &block)
    # 一度色が揃ったボトルは動かさないようにするため
    @complete = false
  end
  attr_accessor :complete
  def pour(bottle)
    org = self.last
    begin
      buf = self.pop
      bottle.push(buf)
    end while (self.size > 0 && bottle.size < MAX_UNIT && self.last == org)
    return true
  end
  def monoCheck
    if self.uniq.size == 1
      return true
    else
      return false
    end
  end
  # 空か同色で満タンならcompleteフラグを立ててtrueを返す
  def check
    return true if self.size == 0
    org = self.first
    self.each_with_index do |color, i|
      return false if color != org
      if (i + 1) == MAX_UNIT
        @complete = true
        return true
      end
    end
    return false
  end
  
end
