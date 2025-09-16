CodeSage

CodeSage is an AI-assisted code review tool. It features a static analysis backend implemented in OCaml with the Dream framework and a live editor frontend built with Svelte. 
The backend includes a production-level Python parser for analyzing code and providing structured feedback.

Features

- Static analysis engine in OCaml  
- Production-grade Python parser  
- Dream-based backend for API and request handling  
- Svelte frontend with live code editor and results view  
- Support for code suggestions and diff highlighting  

Folder structure

CodeSage/
├── backend/ # OCaml + Dream backend and parser
├── frontend/ # Svelte frontend
└── .gitignore


Technologies used : 

- OCaml  
- Dream (OCaml web framework)  
- Menhir / parser combinators for Python parsing  
- Svelte  
- TypeScript  
- HTML / CSS  

## only supports a few syntax for python only will be developing static analysis for most of the of the syntax
## PYTHON ONLY
