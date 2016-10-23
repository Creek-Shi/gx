///////////////////////////////////////////////////////////////////
//
// !!!!!!!!!!!! NEVER MODIFY THIS FILE MANUALLY !!!!!!!!!!!!
//
// This file was auto-generated by tool [github.com/vipally/gogp]
// Last update at: [Sun Oct 23 2016 15:24:25]
// Generate from:
//   [github.com/vipally/gx/math/rand/rand.gp]
//   [github.com/vipally/gx/math/rand/rand.gpg] [32]
//
// Tool [github.com/vipally/gogp] info:
// CopyRight 2016 @Ally Dale. All rights reserved.
// Author  : Ally Dale(vipally@gmail.com)
// Blog    : http://blog.csdn.net/vipally
// Site    : https://github.com/vipally
// BuildAt : [Oct  6 2016 14:25:07]
// Version : 3.0.0.final
// 
///////////////////////////////////////////////////////////////////

//Package rand implements some useful rand object
package rand

import (
	"sync/atomic"
)

var (
	gRand32 = NewRand32S(uint32(RandSeed(0)))
)

//generate a rand number
func Rand32() uint32 {
	return gRand32.Rand()
}

//generate a rand number less than max
func RandMax32(max uint32) uint32 {
	return gRand32.RandMax(max)
}
func RandRange32(min, max uint32) uint32 {
	return gRand32.RandRange(min, max)
}

//rand number generator
//It is thread safe
type Rand32T struct {
	seed uint32
	//lock sync.Mutex
}

//new a initialized rand32 object
func NewRand32S(seed uint32) *Rand32T {
	return &Rand32T{seed: seed}
}

//new a rand32 object initialized by auto-generated seed
func NewRand32() *Rand32T {
	return NewRand32S(gRand32.randBase())
}

//next rand number
func (me *Rand32T) Rand() uint32 {
	var o, n uint32
	for { //mutithread lock-free operation
		o = atomic.LoadUint32(&me.seed)
		n = o*7368787 + 2750159
		if atomic.CompareAndSwapUint32(&me.seed, o, n) {
			break
		}
	}
	return n

	//me.seed = me.seed*g_prime_a32 + g_prime_c32
	//return me.seed
}

//new rand seed list
func (me *Rand32T) randBase() uint32 {
	return uint32(RandSeed(uint64(me.Rand())))
}

//generate rand number in range
func (me *Rand32T) RandRange(min, max uint32) uint32 {
	if max < min {
		max, min = min, max
	}
	d := max - min + 1
	r := me.Rand()
	ret := r%d + min

	return ret
}

//generate rand number with max value
func (me *Rand32T) RandMax(max uint32) uint32 {
	return me.RandRange(0, max-1)
}

//get seed
func (me *Rand32T) Seed() uint32 {
	return atomic.LoadUint32(&me.seed)
}

//set seed
func (me *Rand32T) Srand(_seed uint32) uint32 {
	ret := atomic.SwapUint32(&me.seed, _seed) //mutithread lock-free operation
	return ret
}
