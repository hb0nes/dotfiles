ls.add_snippets("go", {
  s("ie", fmta("if err != nil {\n\treturn <err>\n}", { err = i(1, "err") })),
  s(
    "iel",
    fmta('if err != nil {\n\tlog.Fatalf("Error while <action>: %s", <err>)\n}', { action = i(1), err = i(2, "err") })
  ),
})
