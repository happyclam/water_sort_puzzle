# water_sort_puzzle
ウォーターソートパズル解答プログラム

[「ウォーターソートパズルの答えが知りたい」](https://happyclam.github.io/software/2025-04-27/waterbottle)

~~~Ruby
# ウォーターボトルをBoxに配置
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
~~~

~~~Ruby
#解答プログラム（game_dfs.rbまたはgame_bfs.rb）実行

$ ruby game_bfs.rb
"-----"
"|赤色|赤色|青色|　　|　　|"
"|橙色|橙色|青色|　　|　　|"
"|赤色|青色|橙色|　　|　　|"
"|橙色|青色|赤色|　　|　　|"
"cnt = 497"
"Complete!!"
"counter = 1"
"-----"
"|橙色|青色|　　|赤色|　　|"
"|橙色|青色|　　|赤色|　　|"
"|橙色|青色|　　|赤色|　　|"
"|橙色|青色|　　|赤色|　　|"
"counter = 2"
"-----"
"|橙色|青色|　　|　　|　　|"
"|橙色|青色|　　|赤色|　　|"
"|橙色|青色|　　|赤色|　　|"
"|橙色|青色|赤色|赤色|　　|"
"counter = 3"
"-----"
"|　　|青色|　　|　　|　　|"
"|橙色|青色|　　|赤色|　　|"
"|橙色|青色|橙色|赤色|　　|"
"|橙色|青色|赤色|赤色|　　|"
"counter = 4"
"-----"
"|　　|　　|青色|　　|　　|"
"|橙色|　　|青色|赤色|　　|"
"|橙色|青色|橙色|赤色|　　|"
"|橙色|青色|赤色|赤色|　　|"
"counter = 5"
"-----"
"|　　|橙色|青色|　　|　　|"
"|　　|橙色|青色|赤色|　　|"
"|　　|青色|橙色|赤色|　　|"
"|橙色|青色|赤色|赤色|　　|"
"counter = 6"
"-----"
"|　　|橙色|青色|　　|　　|"
"|　　|橙色|青色|　　|　　|"
"|赤色|青色|橙色|赤色|　　|"
"|橙色|青色|赤色|赤色|　　|"
"counter = 7"
"-----"
"|　　|　　|青色|　　|　　|"
"|橙色|橙色|青色|　　|　　|"
"|赤色|青色|橙色|赤色|　　|"
"|橙色|青色|赤色|赤色|　　|"
"counter = 8"
"-----"
"|　　|赤色|青色|　　|　　|"
"|橙色|橙色|青色|　　|　　|"
"|赤色|青色|橙色|　　|　　|"
"|橙色|青色|赤色|赤色|　　|"
-----
手数: 8手
経過時間: 0.014224148秒
~~~
