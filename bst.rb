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
    arr.uniq!.sort! unless arr.empty?
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

  def delete(value, node = @root)

    if value < node.data
      node.left_child = delete(value, node.left_child)
    elsif value > node.data
      node.right_child = delete(value, node.right_child)
    else
      if node.left_child.nil?
        temp = node.right_child
        node = nil
        return temp
      elsif node.right_child.nil?
        temp = node.left_child
        node = nil
        return temp
      end

      temp = min_value_node(node.right_child)
      node.data = temp.data
      node.right_child = delete(temp.data, node.right_child)
    end

    node
  end

  def find(value, node = @root)
    return if node == nil
    return node if value == node.data

    find(value, node.left_child)
    find(value, node.right_child)
  end

  def level_order
    return nil unless block_given?
    return nil if self.root.nil?

    queue = []
    queue.push(self.root)

    until queue.empty?
      current_node = queue.shift
      queue.push(current_node.left_child) unless current_node.left_child.nil?
      queue.push(current_node.right_child) unless current_node.right_child.nil?
      yield(current_node)
    end
  end

  def preorder(root = @root, &block)
    return if root.nil?
    if block_given?
      yield(root)
      preorder(root.left_child, &block)
      preorder(root.right_child, &block)
    else
      arr = []
      arr.push(root.data)
      arr.push(preorder(root.left_child)).flatten!
      arr.push(preorder(root.right_child)).flatten!
      arr.compact
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  private

  def min_value_node(node)
    # leftmost is our smallest value
    current_node = node
    until current_node.left_child.nil?
      current_node = current_node.left_child
    end

    current_node
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# #arr = [1, 2, 3]
# arr = []
# #arr = [1, 2, 3, 4, 5, 6, 7, 8, 10]
tree = Tree.new(arr)
tree.pretty_print
p tree.preorder