package debug

func Assert(b bool) bool {
	if !b {
		panic("Assert fail\n" + Bts())
	}
	return b
}