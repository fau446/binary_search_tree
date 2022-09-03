class Node
  attr_accessor :data, :left_child, :right_child

  def initialize(data=nil)
    @data = data
    @left_child = nil
    @right_child = nil
  end
end

class Tree
  attr_accessor :size, :root

  def initialize(arr)
    @size = arr.length
    @root = build_tree(arr, 0, size-1)
  end

  def build_tree(arr, start_index, end_index)
    return nil if start_index > end_index

    mid = (start_index + end_index)/2
    root = Node.new(arr[mid])

    root.left_child = build_tree(arr, start_index, mid-1)
    root.right_child = build_tree(arr, mid+1, end_index)

    root
  end

  def insert(value, node = @root) 
    return if value == node.data

    if value < node.data
      if node.left_child == nil
        node.left_child = Node.new(value)
      else
        insert(value, node.left_child)
      end
    else
      if node.right_child == nil
        node.right_child = Node.new(value)
      else
        insert(value, node.right_child)
      end
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
#arr = []
#arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
tree = Tree.new(arr)
tree.insert(0)
p tree.pretty_print