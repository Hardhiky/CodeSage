(* python_rules.ml - The core analysis engine for Python AST *)
open Python_ast

let rec analyze_ast ast =
  List.flatten (List.map analyze_definition ast)

and analyze_definition def =
  match def with
  | FunctionDef (_, _, statements) ->
      List.flatten (List.map analyze_statement statements)

and analyze_statement statement =
  match statement with
  | Expression expr -> analyze_expression expr
  | Return expr -> analyze_expression expr

and analyze_expression expr =
  match expr with
  | Call (Ident "eval", _) ->
      [("Avoid using 'eval' with untrusted input", "Found a direct call to 'eval'.")]
  | Call (Ident "open", _) ->
      [("Close files or use context managers", "Found a call to 'open'.")]
  | Call _ ->
      [] (* Ignore other function calls *)
  | _ -> []
