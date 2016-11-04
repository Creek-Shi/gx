//#GOGP_IGNORE_BEGIN
///////////////////////////////////////////////////////////////////
//
// !!!!!!!!!!!! NEVER MODIFY THIS FILE MANUALLY !!!!!!!!!!!!
//
// This file was auto-generated by tool [github.com/vipally/gogp]
// Last update at: [Fri Nov 04 2016 22:35:37]
// Generate from:
//   [github.com/vipally/gx/stl/gp/tree.go]
//   [github.com/vipally/gx/stl/gp/gp.gpg] [GOGP_REVERSE_tree]
//
// Tool [github.com/vipally/gogp] info:
// CopyRight 2016 @Ally Dale. All rights reserved.
// Author  : Ally Dale(vipally@gmail.com)
// Blog    : http://blog.csdn.net/vipally
// Site    : https://github.com/vipally
// BuildAt : [Oct 24 2016 20:25:45]
// Version : 3.0.0.final
// 
///////////////////////////////////////////////////////////////////
//#GOGP_IGNORE_END

//this file defines a template tree structure just like file system

<PACKAGE>

//#GOGP_REQUIRE(github.com/vipally/gx/stl/gp/fakedef,_)

//#GOGP_REQUIRE(github.com/vipally/gx/stl/gp/functorcmp,tree_sort_slice)

//#GOGP_REQUIRE(github.com/vipally/gx/stl/gp/sort_slice,tree_sort_slice)

func init() {
	g<GLOBAL_NAME_PREFIX>TreeGbl.cmp = g<GLOBAL_NAME_PREFIX>TreeGbl.cmp.CreateByName("#GOGP_GPGCFG(GOGP_DefaultCmpType)")
}

var g<GLOBAL_NAME_PREFIX>TreeGbl struct {
	cmp Cmp<GLOBAL_NAME_PART>
}

//tree strture
type <GLOBAL_NAME_PREFIX>Tree struct {
	cmp  Cmp<GLOBAL_NAME_PART>
	root *<GLOBAL_NAME_PREFIX>TreeNode
}

//new container
func New<GLOBAL_NAME_PREFIX>Tree(bigFirst bool) *<GLOBAL_NAME_PREFIX>Tree {
	p := &<GLOBAL_NAME_PREFIX>Tree{cmp: g<GLOBAL_NAME_PREFIX>TreeGbl.cmp.CreateByBool(bigFirst)}
	return p
}

//tree node
type <GLOBAL_NAME_PREFIX>TreeNode struct {
	<VALUE_TYPE>
	children <GLOBAL_NAME_PREFIX>SortSlice
}

func (this *<GLOBAL_NAME_PREFIX>TreeNode) Less(right *<GLOBAL_NAME_PREFIX>TreeNode) (ok bool) {
	//#GOGP_IFDEF GOGP_HasCmpFunc
	ok = this.<VALUE_TYPE>.Less(right.<VALUE_TYPE>)
	//#GOGP_ELSE
	ok = this.<VALUE_TYPE> < right.<VALUE_TYPE>
	//#GOGP_ENDIF
	return
}

func (this *<GLOBAL_NAME_PREFIX>TreeNode) SortChildren() {
	this.children.Sort()
}

func (this *<GLOBAL_NAME_PREFIX>TreeNode) Children() []*<GLOBAL_NAME_PREFIX>TreeNode {
	return this.children.Buffer()
}

//add a child
func (this *<GLOBAL_NAME_PREFIX>TreeNode) AddChild(v <VALUE_TYPE>, idx int) (child *<GLOBAL_NAME_PREFIX>TreeNode) {
	n := &<GLOBAL_NAME_PREFIX>TreeNode{<VALUE_TYPE>: v}
	return this.AddChildNode(n, idx)
}

//add a child node
func (this *<GLOBAL_NAME_PREFIX>TreeNode) AddChildNode(node *<GLOBAL_NAME_PREFIX>TreeNode, idx int) (child *<GLOBAL_NAME_PREFIX>TreeNode) {
	this.children.Insert(node, idx)
	return node
}

//cound of children
func (this *<GLOBAL_NAME_PREFIX>TreeNode) NumChildren() int {
	return this.children.Len()
}

//get child
func (this *<GLOBAL_NAME_PREFIX>TreeNode) GetChild(idx int) (child *<GLOBAL_NAME_PREFIX>TreeNode, ok bool) {
	child, ok = this.children.Get(idx)
	return
}

//remove child
func (this *<GLOBAL_NAME_PREFIX>TreeNode) RemoveChild(idx int) (child *<GLOBAL_NAME_PREFIX>TreeNode, ok bool) {
	child, ok = this.children.Remove(idx)
	return
}

//create a visitor
func (this *<GLOBAL_NAME_PREFIX>TreeNode) Visitor() (v *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) {
	v = &<GLOBAL_NAME_PREFIX>TreeNodeVisitor{}
	v.push(this, -1)
	return
}

//get all node data
func (this *<GLOBAL_NAME_PREFIX>TreeNode) All() (list []<VALUE_TYPE>) {
	list = append(list, this.<VALUE_TYPE>)
	for _, v := range this.children.Buffer() {
		list = append(list, v.All()...)
	}
	return
}

//tree node visitor
type <GLOBAL_NAME_PREFIX>TreeNodeVisitor struct {
	node         *<GLOBAL_NAME_PREFIX>TreeNode
	parents      []*<GLOBAL_NAME_PREFIX>TreeNode
	brotherIdxes []int
	//visit order: this->child->brother
}

func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) push(n *<GLOBAL_NAME_PREFIX>TreeNode, bIdx int) {
	this.parents = append(this.parents, n)
	this.brotherIdxes = append(this.brotherIdxes, bIdx)
}

func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) pop() (n *<GLOBAL_NAME_PREFIX>TreeNode, bIdx int) {
	l := len(this.parents)
	if l > 0 {
		n, bIdx = this.tail()
		this.parents = this.parents[:l-1]
		this.brotherIdxes = this.brotherIdxes[:l-1]
	}
	return
}

func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) tail() (n *<GLOBAL_NAME_PREFIX>TreeNode, bIdx int) {
	l := len(this.parents)
	if l > 0 {
		n = this.parents[l-1]
		bIdx = this.brotherIdxes[l-1]
	}
	return
}

func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) depth() int {
	return len(this.parents)
}

func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) update_tail(bIdx int) bool {
	l := len(this.parents)
	if l > 0 {
		this.brotherIdxes[l-1] = bIdx
		return true
	}
	return false
}

func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) top_right(n *<GLOBAL_NAME_PREFIX>TreeNode) (p *<GLOBAL_NAME_PREFIX>TreeNode) {
	if n != nil {
		l := n.children.Len()
		for l > 0 {
			this.push(n, l-1)
			n = n.children.MustGet(l - 1)
			l = n.children.Len()
		}
		p = n
	}
	return
}

//visit next node
func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) Next() (data *<VALUE_TYPE>, ok bool) {
	if this.node != nil { //check if has any children
		if this.node.children.Len() > 0 {
			this.push(this.node, 0)
			this.node = this.node.children.MustGet(0)
		} else {
			this.node = nil
		}
	}
	for this.node == nil && this.depth() > 0 { //check if has any brothers or uncles
		p, bIdx := this.tail()
		if bIdx < 0 { //ref parent
			this.node = p
			this.pop()
		} else if bIdx < p.children.Len()-1 { //next brother
			bIdx++
			this.node = p.children.MustGet(bIdx)
			this.update_tail(bIdx)
		} else { //no more brothers
			this.pop()
		}
	}
	if ok = this.node != nil; ok {
		data = this.Get()
	}
	return
}

//visit previous node
func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) Prev() (data *<VALUE_TYPE>, ok bool) {
	if this.node == nil && this.depth() > 0 { //check if has any brothers or uncles
		p, _ := this.pop()
		this.node = this.top_right(p)
		if ok = this.node != nil; ok {
			data = this.Get()
		}
		return
	}

	if this.node != nil { //check if has any children
		p, bIdx := this.tail()
		if bIdx > 0 {
			bIdx--
			this.update_tail(bIdx)
			this.node = this.top_right(p.children.MustGet(bIdx))
		} else {
			this.node = p
			this.pop()
		}
	}
	if ok = this.node != nil; ok {
		data = this.Get()
	}
	return
}

//get node data
func (this *<GLOBAL_NAME_PREFIX>TreeNodeVisitor) Get() *<VALUE_TYPE> {
	return &this.node.<VALUE_TYPE>
}

////for sort
//type __<GLOBAL_NAME_PREFIX>TreeNodeSortSlice []*<GLOBAL_NAME_PREFIX>TreeNode

//func (this *__<GLOBAL_NAME_PREFIX>TreeNodeSortSlice) Sort() {
//	sort.Sort(this)
//}

////data
//func (this *__<GLOBAL_NAME_PREFIX>TreeNodeSortSlice) Buffer() []*<GLOBAL_NAME_PREFIX>TreeNode {
//	return *this
//}

////push
//func (this *__<GLOBAL_NAME_PREFIX>TreeNodeSortSlice) Push(v *<GLOBAL_NAME_PREFIX>TreeNode) int {
//	*this = append(*this, v)
//	return this.Len()
//}

//func (this *__<GLOBAL_NAME_PREFIX>TreeNodeSortSlice) Pop() (r *<GLOBAL_NAME_PREFIX>TreeNode) {
//	if len(*this) > 0 {
//		r = (*this)[len(*this)-1]
//	}
//	*this = (*this)[:len(*this)-1]
//	return
//}

////len
//func (this *__<GLOBAL_NAME_PREFIX>TreeNodeSortSlice) Len() int {
//	return len(this.Buffer())
//}

////sort by Hash decend,the larger one first
//func (this *__<GLOBAL_NAME_PREFIX>TreeNodeSortSlice) Less(i, j int) (ok bool) {
//	l, r := (*this)[i], (*this)[j]
//	return g<GLOBAL_NAME_PREFIX>TreeGbl.cmp.F(l.<VALUE_TYPE>, r.<VALUE_TYPE>)
//}

////swap
//func (this *__<GLOBAL_NAME_PREFIX>TreeNodeSortSlice) Swap(i, j int) {
//	(*this)[i], (*this)[j] = (*this)[j], (*this)[i]
//}

