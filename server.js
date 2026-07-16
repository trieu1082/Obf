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

// Đọc file obfuscator.lua
const LUA_SCRIPT = fs.readFileSync("obfuscator.lua", "utf8")

app.post("/obf", upload.single("file"), (req, res) => {
  let code = req.body.code
  if (req.file) code = req.file.buffer.toString()
  if (!code) return res.json({ err: "no code" })

  const tmpFile = `/tmp/obf_${nanoid(8)}.lua`
  fs.writeFileSync(tmpFile, LUA_SCRIPT)
  let obfCode
  try {
    obfCode = execSync(`lua ${tmpFile}`, { input: code, encoding: "utf8" })
  } catch (e) {
    return res.json({ err: e.stderr ? e.stderr.toString() : e.message })
  } finally {
    fs.unlinkSync(tmpFile)
  }

  const id = nanoid(8)
  fs.writeFileSync(`pastes/${id}.lua`, obfCode)
  res.json({
    code: obfCode,
    download: `/download/${id}`,
    link: `/view/${id}`
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
app.listen(PORT, () => console.log("server running"))
