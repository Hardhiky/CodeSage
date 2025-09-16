
open Lwt.Infix
open Analyzer
open Yojson.Basic.Util

let cors_headers = [
  "Access-Control-Allow-Origin", "*";
  "Access-Control-Allow-Methods", "POST, GET, OPTIONS";
  "Access-Control-Allow-Headers", "Content-Type";
]

let analyze_handler request =
  Dream.body request >>= fun body ->
  try
    let json = Yojson.Basic.from_string body in
    let code = match member "code" json with
      | `String s -> s
      | _ -> ""
    in
    let detected = Lang_detect.detect_language code in

    let static_issues =
      match detected with
      | "Python" ->
          let ast = Python_parser.parse code in
          Python_rules.analyze_ast ast
          |> List.mapi (fun i r ->
              `Assoc [
                ("line", `Int (i + 1));
                ("message", `String (fst r))
              ]
            )
      | _ ->
          [] 
    in

    let response_json = `Assoc [
      ("detected", `String detected);
      ("static", `List static_issues);
      ("ml", `List []) 
    ] in
    Dream.json (Yojson.Basic.to_string response_json)
  with
  | Yojson.Json_error e ->
      Dream.respond ~status:`Bad_Request ("Invalid JSON: " ^ e)
  | Failure e ->
      Dream.respond ~status:`Bad_Request ("Analysis failed: " ^ e)


let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.options "/analyze" (fun _ ->
      Dream.respond ~status:`OK ~headers:cors_headers ""
    );

    Dream.post "/analyze" (fun request ->
      analyze_handler request >>= fun response ->
      List.iter (fun (name, value) -> Dream.add_header response name value) cors_headers;
      Lwt.return response
    );

    Dream.get "/" (fun _ -> Dream.html "OCaml backend running")
  ]
