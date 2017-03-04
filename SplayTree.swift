//Jorge Oses Grijalba 3ºDG INF - MAT
//Order of functions (usually private -> public) has been altered for easier read in public presentation
private class SplayTreeNode<T: Comparable>:Equatable {
    
    
    var parent: SplayTreeNode<T>?
    var leftNode: SplayTreeNode<T>?
    var rightNode: SplayTreeNode<T>?
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    static func ==(A: SplayTreeNode<T>, B: SplayTreeNode<T>) -> Bool {
        return A.value == B.value
    }
    static func <(A: SplayTreeNode<T>, B: SplayTreeNode<T>) -> Bool {
        return A.value < B.value
    }
    static func >(A: SplayTreeNode<T>, B: SplayTreeNode<T>) -> Bool {
        return A.value > B.value
    }
}

public class SplayTree<T: Comparable> {
    
    private var root: SplayTreeNode<T>?
    
    //Key word convenience : lookup swift book, marked reference YELLOW
    public convenience init(_ values: [T]) {
        
        self.init()
        
        for v in values { insert(value: v) }
    }
    
    //Splay : the key of the data structure, will be called after inserting, finding or removing
    //will be presented first for this reason
    //Remember to rename b to a.parent for easier reading in the pdf, easier to understand (?)
    private func splay(_ a: SplayTreeNode<T>) {
        
        while let b = a.parent {
            
            if b.parent == nil {
                
                if a == b.leftNode {
                    rightRotation(a.parent!)
                } else {
                    leftRotation(a.parent!)
                }
                
            } else if a == b.leftNode && b == b.parent!.leftNode {
                
                rightRotation(a.parent!.parent!)
                rightRotation(a.parent!)
                
            } else if a == b.rightNode && a.parent == b.parent!.rightNode {
                
                leftRotation(a.parent!.parent!)
                leftRotation(a.parent!)
            } else if a != b.leftNode || b != b.parent!.rightNode { //faster than before, might be specific example
                
                leftRotation(a.parent!)
                rightRotation(a.parent!)
            } else {
                rightRotation(a.parent!)
                leftRotation(a.parent!)
                
            }
        }
    }
    //used by splay
    private func leftRotation(_ a: SplayTreeNode<T>) {
        
        let ar = a.rightNode
        a.rightNode = ar?.leftNode
        
        if let auxBind = ar?.leftNode  {
            ar?.leftNode?.parent = a
        }
        
        ar?.parent = a.parent
        
        if a.parent == nil {
            
            root = ar
            
        } else if a == a.parent?.leftNode {
            
            a.parent?.leftNode = ar
            
        } else {
            
            a.parent?.rightNode = ar
        }
        
        ar?.leftNode = a
        a.parent = ar
    }
    //used by splay
    private func rightRotation(_ a: SplayTreeNode<T>) {
        
        let al = a.leftNode
        a.leftNode = al?.rightNode
        
        if let auxBind = al?.rightNode {
            al?.rightNode?.parent = a
        }
        
        al?.parent = a.parent
        
        if a.parent == nil {
            
            root = al
            
        } else if a == a.parent?.leftNode {
            
            a.parent?.leftNode = al
            
        } else {
            
            a.parent?.rightNode = al
        }
        
        al?.rightNode = a
        al?.parent = al
    }
    //Done as advised in class -> public func
    func find(_ value: T) -> Bool {
        
        return auxFind(value) == nil ? false : true
    }
    
    private func auxFind(_ value: T) -> SplayTreeNode<T>? {
        
        var actual: SplayTreeNode<T>? = root
        var result: SplayTreeNode<T>?
        
        while let currentOpt = actual {
            
            if currentOpt.value < value {
                
                actual = currentOpt.rightNode
                
            } else if currentOpt.value > value {
                
                actual = currentOpt.leftNode
                
            } else {
                
                splay(actual!)
                result = actual
                break
            }
        }
        
        return result
    }
    
    func insert(value: T) {
        
        var actual: SplayTreeNode<T>? = root
        var parent: SplayTreeNode<T>?
        
        while let optBind = actual {
            
            parent = optBind
            
            if optBind.value < value {
                
                actual = optBind.rightNode
                
            } else if optBind.value > value {
                
                actual = optBind.leftNode
                
            } else {
                
                return
            }
        }
        
        actual = SplayTreeNode(value)
        actual?.parent = parent
        
        if parent == nil {
            
            root = actual
            
        } else if parent!.value >= value {
            
            parent!.leftNode = actual
        } else {
            parent!.rightNode = actual
            
        }
        
        splay(actual!)
    }
    
    
    
    func remove(_ value: T) -> Bool {
        
        let node = auxFind(value)
        
        if let node = node {
            splay(node)
            
            if let left = node.leftNode{
                
                if let right = node.rightNode{
                    let lsRoot     = node.leftNode
                    let rsRoot    = node.rightNode
                    
                    node.leftNode  = nil;
                    node.rightNode = nil;
                    
                    lsRoot?.parent  = nil;
                    rsRoot?.parent = nil;
                    
                    root = lsRoot
                    let maxL = maxInTree(lsRoot!)
                    splay(maxL)
                    root?.rightNode = rsRoot
                    rsRoot?.parent = root
                } else{
                    root = node.leftNode
                    node.leftNode?.parent = nil
                }
            } else {
                root = node.rightNode
                node.rightNode?.parent = nil
            }
           
            
            return true
            
        } else {
            
            return false
        }
    }
    private func maxInTree(_ start: SplayTreeNode<T>) -> SplayTreeNode<T> {
        
        var node: SplayTreeNode<T> = start
        while let b = node.rightNode {
            node = b
        }
        
        return node
    }
    
    func preorderTraversal() -> [T] {
        
        var pTraversal: [T] = []
        
        preorderTraversalAux(root, traversal: &pTraversal)
        
        return pTraversal
    }
    func inorderTraversal() -> [T] {
        
        var iTraversal: [T] = []
        
        inorderTraversalAux(root, traversal: &iTraversal)
        
        return iTraversal
    }
    func postorderTraversal() -> [T] {
        
        var pTraversal: [T] = []
        
        postorderTraversalAux(root, traversal: &pTraversal)
        
        return pTraversal
    }
    private func preorderTraversalAux(_ a: SplayTreeNode<T>?, traversal: inout [T]) {
        
        if let a = a {
            
            traversal.append(a.value)
            preorderTraversalAux(a.leftNode, traversal: &traversal)
            preorderTraversalAux(a.rightNode, traversal: &traversal)
        }
    }
    private func inorderTraversalAux(_ a: SplayTreeNode<T>?, traversal: inout [T]) {
        
        if let a = a {
            
            inorderTraversalAux(a.leftNode, traversal: &traversal)
            traversal.append(a.value)
            inorderTraversalAux(a.rightNode, traversal: &traversal)
        }
    }
    
    private func postorderTraversalAux(_ a: SplayTreeNode<T>?, traversal: inout [T]) {
        
        if let a = a {
            
            postorderTraversalAux(a.leftNode, traversal: &traversal)
            postorderTraversalAux(a.rightNode, traversal: &traversal)
            traversal.append(a.value)
        }
    }
}
