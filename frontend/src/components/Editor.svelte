<script lang="ts">
  import { onMount, onDestroy } from "svelte"
  import * as monaco from "monaco-editor"

  export let code: string
  let editorContainer: HTMLDivElement
  let editor: monaco.editor.IStandaloneCodeEditor

  onMount(() => {
    editor = monaco.editor.create(editorContainer, {
      value: code,
      language: "javascript", // or "typescript", "ocaml", etc.
      theme: "vs-dark",
      automaticLayout: true
    })
    editor.getAction("editor.action.formatDocument").run()
    // Update parent `code` whenever Monaco content changes
    const model: monaco.editor.ITextModel | null = editor.getModel()
 
    const sub: monaco.IDisposable | undefined = model?.onDidChangeContent(() => {
      code = editor.getValue()
    })

    return () => {
      sub?.dispose()
      editor.dispose()
    }
  })
</script>

<div bind:this={editorContainer} class="w-full h-64 border rounded"></div>

<style>
  .monaco-editor {
    border-radius: 0.5rem;
  }
</style>
