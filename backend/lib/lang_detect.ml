(* lang_detect.ml *)
let contains pattern code =
  try ignore (Str.search_forward (Str.regexp pattern) code 0); true
  with Not_found -> false

let detect_language code =
  let code = String.lowercase_ascii code in
  if contains "def\\|import" code then "Python"
  else if contains "fun\\|let\\|->" code then "OCaml"
  else if contains "console.log" code then "JavaScript"
  else if contains "<?php" code then "PHP"
  else if contains "fn\\|mod\\|use" code then "Rust"
  else if contains "package\\|import\\|func" code then "Go"
  else if contains "public\\|class\\|static" code then "Java"
  else if contains "namespace\\|using\\|class" code then "C#"
  else if contains "#include\\|#define" code then "C++"
  else if contains "let\\|var\\|func" code then "Swift"
  else if contains "fun\\|val\\|var" code then "Kotlin"
  else "Unknown"
