local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("cfo", { -- check for error
		t("if err != nil {"), t({ "", "\t" }),
		i(1, "return err"),
		t({ "", "}" })
	}),
	s("struct", {
		t("type "), i(1, "MyStruct"), t(" struct {"),
		t({ "", "\t" }), i(2, "Field type"),
		t({ "", "}" })
	}),
}
