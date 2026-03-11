function r(n){
 const c="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
 let s=""
 for(let i=0;i<n;i++) s+=c[Math.floor(Math.random()*c.length)]
 return s
}

function enc(s){
 let a=[]
 for(let i=0;i<s.length;i++) a.push((s.charCodeAt(i)+7)^3)
 return `{${a.join(",")}}`
}

function rename(code){

 let map={}

 code=code.replace(/\blocal\s+([a-zA-Z_]\w*)/g,(m,v)=>{
  if(!map[v]) map[v]="_"..r(12)
  return "local "..map[v]
 })

 for(const k in map){
  const re=new RegExp("\\b"+k+"\\b","g")
  code=code.replace(re,map[k])
 }

 return code
}

function strenc(code){

 return code.replace(/"(.*?)"/g,(m,v)=>{
  return `_S(${enc(v)})`
 })

}

function numenc(code){

 return code.replace(/\b\d+\b/g,n=>{
  let k=Math.floor(Math.random()*9)+3
  return `(${n*k}/${k})`
 })

}

function dead(){

 return `
local ${r(6)}=${Math.floor(Math.random()*99999)}
if ${Math.floor(Math.random()*5)}==${Math.floor(Math.random()*5)} then
 local ${r(6)}=${Math.random()}
end
`
}

function opaque(){

 let a=Math.floor(Math.random()*9999)
 let b=a*3
 return `if (${b}/3)==${a} then`
}

function flatten(code){

 return `
local _s=${Math.floor(Math.random()*3)+1}

while true do

 if _s==1 then
  _s=2

 elseif _s==2 then
  ${code}
  _s=3

 elseif _s==3 then
  break
 end

end
`
}

function junkfunc(){

 return `
local function ${r(8)}(...)
 local t={...}
 for i=1,#t do
  t[i]=t[i]
 end
 return t
end
`
}

function vmwrap(code){

 const b=Buffer.from(code).toString("base64")

 return `

local _B="${b}"

local function _S(t)
 local s=""
 for i,v in ipairs(t)do
  s=s..string.char((v~3)-7)
 end
 return s
end

local function _R(x)
 local f=loadstring(x)
 return f()
end

_R(game:GetService("HttpService"):Base64Decode(_B))
`
}

function anti(){

return `
pcall(function()

 if hookfunction then
  error("hook")
 end

 if debug then
  debug.getinfo=function()return nil end
  debug.getupvalue=function()return nil end
 end

 for _,v in pairs(getgc(true)) do
  if type(v)=="function" then
   local i=debug.getinfo(v)
   if i and i.source and i.source:find("executor") then
    while true do end
   end
  end
 end

end)
`
}

export function obfuscate(code){

 code=rename(code)

 code=strenc(code)

 code=numenc(code)

 code=dead()+code+dead()

 code=flatten(code)

 code=junkfunc()+code+junkfunc()

 code=opaque()+"\n"+code+"\nend"

 code=vmwrap(code)

 return `-- obf by trieu(test v1)

${anti()}

${code}
`
}
