export async function analyzeCode(code: string) {
  const res = await fetch("http://localhost:8080/analyze", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ code })
  })
  return await res.json()
}

