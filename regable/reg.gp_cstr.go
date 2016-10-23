///////////////////////////////////////////////////////////////////
//
// !!!!!!!!!!!! NEVER MODIFY THIS FILE MANUALLY !!!!!!!!!!!!
//
// This file was auto-generated by tool [github.com/vipally/gogp]
// Last update at: [Sun Oct 23 2016 15:24:25]
// Generate from:
//   [github.com/vipally/gx/regable/reg.gp]
//   [github.com/vipally/gx/regable/reg.gpg] [cstr]
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

package regable

import (
	"bytes"
	"fmt"
	//"sync"
	"github.com/vipally/gx/consts"
	"github.com/vipally/gx/errors"
	xmath "github.com/vipally/gx/math"
)

const (
	default_cstr_reg_cnt = 1024
)

var (
	g_cstr_rgr_id_gen, _         = amath.NewRangeUint32(g_invalid_id+1, g_invalid_id, g_max_reger_id)
	errid_cstr_id, _  = aerr.Reg("ConstStringId error")
	errid_cstr_obj, _ = aerr.Reg("ConstString object error")
)

var (
	g_cstr_reger_list []*ConstStringReger
)

func init() {
	reg_show(ShowAllConstStringRegers)
}

//new reger
func NewConstStringReger(name string) (r *ConstStringReger, err error) {
	defer func() {
		if err != nil {
			panic(err)
		}
	}()
	if err = check_lock(); err != nil {
		return
	}
	id := g_invalid_id
	if id, err = g_cstr_rgr_id_gen.Inc(); err != nil {
		return
	}
	p := new(ConstStringReger)
	if err = p.init(name); err == nil {
		p.reger_id = uint8(id)
		r = p
		g_cstr_reger_list = append(g_cstr_reger_list, p)
	}
	return
}

func MustNewConstStringReger(name string) (r *ConstStringReger) {
	if reg, err := NewConstStringReger(name); err != nil {
		panic(err)
	} else {
		r = reg
	}
	return
}

//show all regers
func ShowAllConstStringRegers() string {
	var buf bytes.Buffer
	s := fmt.Sprintf("[ConstStringRegers] count:%d", len(g_cstr_reger_list))
	buf.WriteString(s)
	for _, v := range g_cstr_reger_list {
		buf.WriteString(consts.NewLine)
		buf.WriteString(v.String())
	}
	return buf.String()
}

//reger object
type ConstStringReger struct {
	reger_id uint8
	name     string
	id_gen   amath.RangeUint32
	reg_list []*_const_strRecord
}

func (me *ConstStringReger) init(name string) (err error) {
	me.name = name
	if err = me.id_gen.Init(g_invalid_id+1, g_invalid_id,
		g_invalid_id+default_cstr_reg_cnt); err != nil {
		return
	}
	me.reg_list = make([]*_const_strRecord, 0, 0)
	return
}

//set max reg count at a reger
func (me *ConstStringReger) MaxReg(max_regs uint32) (rmax uint32, err error) {
	if err = verify_max_regs(max_regs); err != nil {
		return
	}
	cur, min, _ := me.id_gen.Get()
	if err = me.id_gen.Init(cur, min, g_invalid_id+max_regs); err != nil {
		return
	}
	rmax = me.id_gen.Max()
	return
}

//reg a value
func (me *ConstStringReger) Reg(/*name string,*/ val string) (r ConstStringId, err error) {
	r = ConstStringId(g_invalid_id)
	defer func() {
		if err != nil {
			panic(err)
		}
	}()
	id := g_invalid_id
	if err = check_lock(); err != nil {
		return
	}
	if id, err = me.id_gen.Inc(); err != nil {
		return
	}
	p := me.new_rec(/*name,*/ val)
	p.id = id
	me.reg_list = append(me.reg_list, p)
	r = ConstStringId(MakeRegedId(uint32(me.reger_id), id))
	return
}

func (me *ConstStringReger) MustReg(/*name string,*/ val string) (r ConstStringId) {
	if reg, err := me.Reg(/*name,*/ val); err != nil {
		panic(err)
	} else {
		r = reg
	}
	return
}

//show string
func (me *ConstStringReger) String() string {
	var buf bytes.Buffer
	s := fmt.Sprintf("[ConstStringReger#%d: %s] ids:%s",
		me.reger_id, me.name, me.id_gen.String())
	buf.WriteString(s)
	for i, v := range me.reg_list {
		//v.lock.RLock()
		s = fmt.Sprintf("\n#%d [%s]: %v",
			uint32(i)+g_invalid_id+1, ""/*v.name*/,
			v.val)
		//v.lock.RUnlock()
		buf.WriteString(s)
	}
	return buf.String()
}

type _const_strRecord struct {
	/*name string*/
	val  string
	id   uint32
	//lock sync.RWMutex
}

func (me *ConstStringReger) new_rec(/*name string,*/ val string) (r *_const_strRecord) {
	r = new(_const_strRecord)
	/*r.name = name*/
	r.val = val
	return
}

type ConstStringId regedId

func (cp ConstStringId) get() (rg *ConstStringReger, r *_const_strRecord, err error) {
	idrgr, id := regedId(cp).ids()
	idregidx, idx := idrgr-g_invalid_id-1, id-g_invalid_id-1
	if idrgr == g_invalid_id || !g_cstr_rgr_id_gen.InCurrentRange(idrgr) {
		err = aerr.New(errid_cstr_id)
	}
	rg = g_cstr_reger_list[idregidx]
	if id == g_invalid_id || !rg.id_gen.InCurrentRange(id) {
		err = aerr.New(errid_cstr_id)
	}
	r = rg.reg_list[idx]
	return
}

//check if valid
func (cp ConstStringId) Valid() (rvalid bool) {
	if _, _, e := cp.get(); e == nil {
		rvalid = true
	}
	return
}

//get value
func (cp ConstStringId) Get() (r string, err error) {
	_, rc, e := cp.get()
	if e != nil {
		return r, e
	}
	return rc.Get()
}

//get value with out error, if has error will cause panic
func (cp ConstStringId) GetNoErr() (r string) {
	_, rc, e := cp.get()
	if e != nil {
		panic(e.Error())
	}
	return rc.GetNoErr()
}

//set value
//func (cp ConstStringId) Set(val string) (r string, err error) {
//	_, rc, e := cp.get()
//	if e != nil {
//		return r, e
//	}
//	return rc.Set(val)
//}

//reverse bool value(as a switch)
//func (cp ConstStringId) Reverse() (r string, err error) {
//	_, rc, e := cp.get()
//	if e != nil {
//		return r, e
//	}
//	return rc.Reverse()
//}

//get reger_id and real_id
func (cp ConstStringId) Ids() (reger_id, real_id uint32) {
	return regedId(cp).ids()
}

//show string
func (cp ConstStringId) String() (r string) {
	idrgr, id := regedId(cp).ids()
	_, rc, err := cp.get()
	if err != nil {
		r = fmt.Sprintf("invalid ConstStringId#(%d|%d)", idrgr, id)
	} else {
		r = rc.String()
	}
	return
}

//get name
/*
func (cp ConstStringId) Name() (r string, err error) {
	_, rc, e := cp.get()
	if e == nil {
		r, err = rc.Name()
	} else {
		err = e
	}
	return
}
*/

//get as object for fast access
func (cp ConstStringId) Oject() (r ConstStringObj) {
	_, rc, e := cp.get()
	if e == nil {
		r.obj = rc
	}
	return
}

//get name
/*
func (me *_const_strRecord) Name() (r string, err error) {
	if me != nil {
//		me.lock.RLock()
//		defer me.lock.RUnlock()
		r = me.name
	} else {
		err = aerr.New(errid_cstr_obj)
	}
	return
}
*/

//get value
func (me *_const_strRecord) Get() (r string, err error) {
	if me != nil {
//		me.lock.RLock()
//		defer me.lock.RUnlock()
		r = me.val
	} else {
		err = aerr.New(errid_cstr_obj)
	}
	return
}

//get value without error,if has error will cause panic
func (me *_const_strRecord) GetNoErr() (r string) {
	r0, err := me.Get()
	if err != nil {
		panic(err.Error())
	}
	r = r0
	return
}

//set value
//func (me *_const_strRecord) Set(val string) (r string, err error) {
//	if nil != me {
//		me.lock.Lock()
//		defer me.lock.Unlock()
//		me.val = val
//		r = val
//	} else {
//		err = aerr.New(errid_cstr_obj)
//	}
//	return
//}

//reverse on bool value
//func (me *_const_strRecord) Reverse() (r string, err error) {
//	if nil != me {
////		me.lock.Lock()
////		defer me.lock.Unlock()
//		me.val = !me.val
//		r = me.val
//	} else {
//		err = aerr.New(errid_cstr_obj)
//	}
//	return
//}

//get as Id
func (me *_const_strRecord) Id() (r ConstStringId) {
	if me != nil {
		r = ConstStringId(me.id)
	}
	return
}

//show string
func (me *_const_strRecord) String() (r string) {
	if me != nil {
		idrgr, id := regedId(me.id).ids()
//		me.lock.RLock()
//		defer me.lock.RUnlock()
		r = fmt.Sprintf("ConstString#(%d|%d|%s)%v", idrgr, id, ""/*me.name*/, me.val)
	} else {
		r = fmt.Sprintf("invalid string object")
	}
	return
}

//object of reged value,it is more efficient to access than Id object
type ConstStringObj struct {
	obj *_const_strRecord
}

//check if valid
func (cp ConstStringObj) Valid() (rvalid bool) {
	return cp.obj != nil
}

//get value
func (cp ConstStringObj) Get() (r string, err error) {
	return cp.obj.Get()
}

//get value against error,if has error will cause panic
func (cp ConstStringObj) GetNoErr() (r string) {
	return cp.obj.GetNoErr()
}

//set value
//func (cp ConstStringObj) Set(val string) (r string, err error) {
//	return cp.obj.Set(val)
//}

//reverse bool object
//func (cp ConstStringObj) Reverse() (r string, err error) {
//	return cp.obj.Reverse()
//}

//show string
func (cp ConstStringObj) String() (r string) {
	return cp.obj.String()
}

//get name
/*
func (cp ConstStringObj) Name() (r string, err error) {
	return cp.obj.Name()
}
*/

//get as Id
func (cp ConstStringObj) Id() (r ConstStringId) {
	return cp.obj.Id()
}

//reg and return an object agent
func (me *ConstStringReger) RegO(/*name string,*/ val string) (r ConstStringObj, err error) {
	id, e := me.Reg(/*name,*/ val)
	if e == nil {
		r = id.Oject()
	} else {
		err = e
	}
	return
}

func (me *ConstStringReger) MustRegO(/*name string,*/ val string) (r ConstStringObj) {
	if reg, err := me.RegO(/*name,*/ val); err != nil {
		panic(err)
	} else {
		r = reg
	}
	return
}
