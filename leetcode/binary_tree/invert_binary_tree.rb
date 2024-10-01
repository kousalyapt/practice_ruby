def invert_tree(root)
    return if root.nil?
    temp =  root.left
    root.left = root.right  
    root.right = temp
    invert_tree(root.left)
    invert_tree(root.right)
    root
end
