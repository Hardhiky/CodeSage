<script lang="ts">
  import Editor from "./components/Editor.svelte"
  import Results from "./components/Results.svelte"

  let code = "function hello() { console.log('Hello') }"

  interface BackendData {
    detected?: string;
    static?: { line: number; message: string }[];
    ml?: { line: number; suggestion: string }[];
  }

  let results: { static: { line: number; message: string }[]; ml: { line: number; suggestion: string }[] } = {
    static: [],
    ml: []
  }

  async function analyze() {
    if (typeof code !== 'string' || code.trim() === '') {
      results = {
        static: [{ line: 0, message: "No code to analyze" }],
        ml: []
      }
      return
    }

    try {
      const res = await fetch("http://localhost:8080/analyze", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code })
      })
      const data: BackendData = await res.json()

      results = {
        static: data.static ?? [],
        ml: data.ml ?? []
      }
    } catch (err) {
      results = {
        static: [{ line: 0, message: "Error contacting backend" }],
        ml: []
      }
    }
  }
</script>

<div class="flex flex-col items-center space-y-4 p-6 w-full max-w-2xl">
  <Editor bind:code={code} />
  <button
    class="px-4 py-2 bg-blue-600 text-white rounded-lg"
    on:click={analyze}
  >
    Analyze
  </button>
  <Results {results} />
</div>
