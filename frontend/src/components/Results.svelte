<script lang="ts">
  export let results: {
    static?: { line: number; message: string }[];
    ml?: { line: number; suggestion: string }[];
  }
</script>

<div class="p-4 text-sm w-full max-w-2xl">
  {#if results}
    <h2 class="font-bold text-lg mb-2">Static Analysis</h2>
    <ul class="list-disc ml-5 space-y-1">
      {#each results.static ?? [] as issue}
        <li>{issue.line}: {issue.message}</li>
      {/each}
    </ul>

    <h2 class="font-bold text-lg mt-4 mb-2">ML Suggestions</h2>
    <ul class="list-disc ml-5 space-y-1">
      {#each results.ml ?? [] as suggestion}
        <li>{suggestion.line}: {suggestion.suggestion}</li>
      {/each}
    </ul>
  {/if}
</div>
