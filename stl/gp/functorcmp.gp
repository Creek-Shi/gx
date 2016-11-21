//#GOGP_IGNORE_BEGIN
///////////////////////////////////////////////////////////////////
//
// !!!!!!!!!!!! NEVER MODIFY THIS FILE MANUALLY !!!!!!!!!!!!
//
// This file was auto-generated by tool [github.com/vipally/gogp]
// Last update at: [Mon Nov 21 2016 22:57:32]
// Generate from:
//   [github.com/vipally/gx/stl/gp/functorcmp.gp.go]
//   [github.com/vipally/gx/stl/gp/gp.gpg] [GOGP_REVERSE_functorcmp]
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

//this file is used to import by other gp files
//it cannot use independently, simulation C++ stl functors

<PACKAGE>

//#GOGP_REQUIRE(github.com/vipally/gx/stl/gp/fakedef,_)

//#GOGP_ONCE
const (
	CMPLesser = iota //default
	CMPGreater
) //
//#GOGP_END_ONCE

//cmp object, zero is Lesser
type Cmp<GLOBAL_NAME_PREFIX> byte

const (
	Cmp<GLOBAL_NAME_PREFIX>Lesser  Cmp<GLOBAL_NAME_PREFIX> = CMPLesser
	Cmp<GLOBAL_NAME_PREFIX>Greater Cmp<GLOBAL_NAME_PREFIX> = CMPGreater
)

//create cmp object by name
func CreateCmp<GLOBAL_NAME_PREFIX>(cmpName string) (r Cmp<GLOBAL_NAME_PREFIX>) {
	r = Cmp<GLOBAL_NAME_PREFIX>Lesser.CreateByName(cmpName)
	return
}

//uniformed global function
func (me Cmp<GLOBAL_NAME_PREFIX>) F(left, right <VALUE_TYPE>) (ok bool) {
	switch me {
	case CMPLesser:
		ok = me.less(left, right)
	case CMPGreater:
		ok = me.great(left, right)
	}
	return
}

//Lesser object
func (me Cmp<GLOBAL_NAME_PREFIX>) Lesser() Cmp<GLOBAL_NAME_PREFIX> { return CMPLesser }

//Greater object
func (me Cmp<GLOBAL_NAME_PREFIX>) Greater() Cmp<GLOBAL_NAME_PREFIX> { return CMPGreater }

//show as string
func (me Cmp<GLOBAL_NAME_PREFIX>) String() (s string) {
	switch me {
	case CMPLesser:
		s = "Lesser"
	case CMPGreater:
		s = "Greater"
	default:
		s = "error cmp value"
	}
	return
}

//create by bool
func (me Cmp<GLOBAL_NAME_PREFIX>) CreateByBool(bigFirst bool) (r Cmp<GLOBAL_NAME_PREFIX>) {
	if bigFirst {
		r = CMPGreater
	} else {
		r = CMPLesser
	}
	return
}

//create cmp object by name
func (me Cmp<GLOBAL_NAME_PREFIX>) CreateByName(cmpName string) (r Cmp<GLOBAL_NAME_PREFIX>) {
	switch cmpName {
	case "": //default Lesser
		fallthrough
	case "Lesser":
		r = CMPLesser
	case "Greater":
		r = CMPGreater
	default: //unsupport name
		panic(cmpName)
	}
	return
}

//lesser operation
func (me Cmp<GLOBAL_NAME_PREFIX>) less(left, right <VALUE_TYPE>) (ok bool) {
	//#GOGP_IFDEF GOGP_HasCmpFunc
	ok = left.Less(right)
	//#GOGP_ELSE
	ok = left < right
	//#GOGP_ENDIF
	return
}

//Greater operation
func (me Cmp<GLOBAL_NAME_PREFIX>) great(left, right <VALUE_TYPE>) (ok bool) {
	//#GOGP_IFDEF GOGP_HasCmpFunc
	ok = right.Less(left)
	//#GOGP_ELSE
	ok = right < left
	//#GOGP_ENDIF
	return
}

