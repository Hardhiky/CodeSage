
type expression =
  | Ident of string
  | String of string
  | Int of int
  | Call of expression * expression list
  | Var of string
  | Empty

type statement =
  | Expression of expression
  | Return of expression

type definition =
  | FunctionDef of string * string list * statement list

type t = definition list
