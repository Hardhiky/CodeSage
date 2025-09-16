(* python_parser.ml - A highly simplified, hand-written Python parser.
   WARNING: This is for demonstration purposes only. It will fail on
   most real-world Python code. It is designed to parse the
   test cases we discussed.
*)
open Python_ast

let tokenize code =
  let code = Str.global_replace (Str.regexp "[(]") " ( " code in
  let code = Str.global_replace (Str.regexp "[)]") " ) " code in
  let code = Str.global_replace (Str.regexp "[ \t\n]+") " " code in
  Str.split (Str.regexp " ") (String.trim code)

let parse_expression tokens =
  match tokens with
  | ("eval" :: "(" :: arg :: ")":: rest) ->
      Call (Ident "eval", [Ident arg]), rest
  | (name :: rest) ->
      Ident name, rest
  | [] -> Empty, []

let parse_statements tokens =
  match tokens with
  | "return" :: rest ->
      let expr, rest_tokens = parse_expression rest in
      [Return expr], rest_tokens
  | (s :: rest) ->
      let expr, rest_tokens = parse_expression (s :: rest) in
      [Expression expr], rest_tokens
  | [] -> [], []

let parse_function_def tokens =
  match tokens with
  | "def" :: name :: "(" :: arg :: ")" :: ":" :: rest ->
      let statements, _ = parse_statements rest in
      FunctionDef (name, [arg], statements), []
  | _ -> failwith "Failed to parse function definition"

let parse code =
  let tokens = tokenize code in
  let def, _ = parse_function_def tokens in
  [def]
