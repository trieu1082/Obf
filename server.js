import express from "express"
import multer from "multer"
import fs from "fs"
import { nanoid } from "nanoid"
import { execSync } from "child_process"

const app = express()
const upload = multer()

app.use(express.json({ limit: "5mb" }))
app.use(express.static("public"))

if (!fs.existsSync("pastes")) fs.mkdirSync("pastes")

const LUA_SCRIPT = fs.readFileSync("obfuscator.lua", "utf8")
console.log("✅ Loaded obfuscator.lua, length:", LUA_SCRIPT.length)

app.post("/obf", upload.single("file"), (req, res) => {
  let code = req.body.code
  if (req.file) code = req.file.buffer.toString()
  if (!code) return res.status(400).json({ err: "no code" })

  const tmpFile = `/tmp/obf_${nanoid(8)}.lua`
  fs.writeFileSync(tmpFile, LUA_SCRIPT)

  let obfCode
  try {
    // Gọi tuyệt đối /usr/bin/lua (đã được symlink trong Docker)
    obfCode = execSync(`/usr/bin/lua ${tmpFile}`, {
      input: code,
      encoding: "utf8",
      timeout: 10000,
    })
  } catch (e) {
    console.error("❌ Lua error:", e.message)
    const stderr = e.stderr ? e.stderr.toString() : e.message
    return res.status(500).json({ err: stderr })
  } finally {
    try { fs.unlinkSync(tmpFile) } catch (_) {}
  }

  const id = nanoid(8)
  fs.writeFileSync(`pastes/${id}.lua`, obfCode)
  res.json({
    code: obfCode,
    download: `/download/${id}`,
    link: `/view/${id}`,
  })
})

app.get("/download/:id", (req, res) => {
  res.download(`pastes/${req.params.id}.lua`)
})

app.get("/view/:id", (req, res) => {
  const file = `pastes/${req.params.id}.lua`
  if (!fs.existsSync(file)) return res.send("not found")
  const code = fs.readFileSync(file, "utf8")
  res.send(`
    <pre style="white-space:pre-wrap;font-family:monospace;background:#0f0f0f;color:#0f0;padding:20px">
    ${code.replaceAll("<", "&lt;")}
    </pre>
  `)
})

const PORT = process.env.PORT || 3000
app.listen(PORT, () => console.log("🚀 Server running on port", PORT))
