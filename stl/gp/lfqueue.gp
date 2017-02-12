//#GOGP_IGNORE_BEGIN
///////////////////////////////////////////////////////////////////
//
// !!!!!!!!!!!! NEVER MODIFY THIS FILE MANUALLY !!!!!!!!!!!!
//
// This file was auto-generated by tool [github.com/vipally/gogp]
// Last update at: [Mon Jan 23 2017 10:03:42]
// Generate from:
//   [github.com/vipally/gx/stl/gp/lfqueue.gp.go]
//   [github.com/vipally/gx/stl/gp/gp.gpg] [GOGP_REVERSE_lfqueue]
//
// Tool [github.com/vipally/gogp] info:
// CopyRight 2016 @Ally Dale. All rights reserved.
// Author  : Ally Dale(vipally@gmail.com)
// Blog    : http://blog.csdn.net/vipally
// Site    : https://github.com/vipally
// BuildAt : [Oct  8 2016 10:34:35]
// Version : 3.0.0.final
// 
///////////////////////////////////////////////////////////////////
//#GOGP_IGNORE_END

<PACKAGE>

import (
	"sync/atomic"
	"unsafe"
)

//#GOGP_REQUIRE(github.com/vipally/gogp/lib/fakedef,_)

//list node
type <GLOBAL_NAME_PREFIX>LFQueueNode struct {
	val  <VALUE_TYPE>
	next unsafe.Pointer
}

//single-way link list object
type <GLOBAL_NAME_PREFIX>LFQueue struct {
	head <GLOBAL_NAME_PREFIX>LFQueueNode //head is a dummy node, not a pionter
	//tail unsafe.Pointer
	size int32
}

func (this *<GLOBAL_NAME_PREFIX>LFQueue) makeNode(v <VALUE_TYPE>) (n *<GLOBAL_NAME_PREFIX>LFQueueNode) {
	n = &<GLOBAL_NAME_PREFIX>LFQueueNode{}
	n.val = v
	n.next = nil
	return
}

func (this *<GLOBAL_NAME_PREFIX>LFQueue) PushFront(v <VALUE_TYPE>) bool {
	n := this.makeNode(v)
	p := unsafe.Pointer(n)
	for {
		n.next = atomic.LoadPointer(&this.head.next)
		if atomic.CompareAndSwapPointer(&this.head.next, n.next, p) {
			break
		}
	}
	//	if atomic.LoadPointer(&this.tail) == nil {
	//		atomic.StorePointer(&this.tail, p)
	//	}
	atomic.AddInt32(&this.size, 1)
	return true
}

//func (this *<GLOBAL_NAME_PREFIX>LFQueue) PushBack(v <VALUE_TYPE>) bool {
//	n := this.makeNode(v)
//	p := unsafe.Pointer(n)
//	for {
//		t := atomic.LoadPointer(&this.tail)
//		if t == nil {
//			atomic.CompareAndSwapPointer(&this.tail, nil, p)
//			if atomic.CompareAndSwapPointer(&this.head.next, nil, p) {
//				break
//			}
//		} else {
//			tt := (*<GLOBAL_NAME_PREFIX>LFQueueNode)(t)
//			if atomic.CompareAndSwapPointer(&this.tail, t, p) {
//				tt.next = p
//				break
//			}
//		}
//	}
//	atomic.AddInt32(&this.size, 1)
//	return true
//}

func (this *<GLOBAL_NAME_PREFIX>LFQueue) PopFront() (v <VALUE_TYPE>, ok bool) {
	for {
		t := atomic.LoadPointer(&this.head.next)
		if t == nil {
			break
		} else {
			n := (*<GLOBAL_NAME_PREFIX>LFQueueNode)(t)
			next := n.next
			if atomic.CompareAndSwapPointer(&this.head.next, t, next) {
				v, ok = n.val, true
				break
			}
		}
	}
	atomic.AddInt32(&this.size, -1)
	return
}

func (this *<GLOBAL_NAME_PREFIX>LFQueue) Clear() {
	atomic.StorePointer(&this.head.next, nil)
	//atomic.StorePointer(&this.tail, nil)
}

//func (this *<GLOBAL_NAME_PREFIX>LFQueue) PopBack() (v <VALUE_TYPE>, ok bool)  { return }

func (this *<GLOBAL_NAME_PREFIX>LFQueue) Size() int {
	return int(atomic.LoadInt32(&this.size))
}

func (this *<GLOBAL_NAME_PREFIX>LFQueue) Empty() bool {
	return atomic.LoadPointer(&this.head.next) == nil
}
