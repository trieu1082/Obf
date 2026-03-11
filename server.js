import express from "express"
import multer from "multer"
import fs from "fs"
import { nanoid } from "nanoid"
import { obfuscate } from "./obf.js"

const app = express()
const upload = multer()

app.use(express.json({limit:"5mb"}))
app.use(express.static("public"))

if(!fs.existsSync("pastes")) fs.mkdirSync("pastes")

app.post("/obf", upload.single("file"), (req,res)=>{

 let code = req.body.code

 if(req.file){
  code = req.file.buffer.toString()
 }

 if(!code) return res.json({err:"no code"})

 const obf = obfuscate(code)

 const id = nanoid(8)
 fs.writeFileSync(`pastes/${id}.lua`, obf)

 res.json({
  code: obf,
  download:`/download/${id}`,
  link:`/view/${id}`
 })

})

app.get("/download/:id",(req,res)=>{
 res.download(`pastes/${req.params.id}.lua`)
})

app.get("/view/:id",(req,res)=>{

 const file=`pastes/${req.params.id}.lua`

 if(!fs.existsSync(file)) return res.send("not found")

 const code=fs.readFileSync(file,"utf8")

 res.send(`
 <pre style="white-space:pre-wrap;font-family:monospace;background:#0f0f0f;color:#0f0;padding:20px">
${code.replaceAll("<","&lt;")}
 </pre>
 `)

})

app.listen(3000,()=>console.log("obf web running"))
