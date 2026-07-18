local _MODULES = {}
local function require_impl(name)
  local mod = _MODULES[name]
  if mod then
    if type(mod) == "function" then
      mod = mod()
      _MODULES[name] = mod
    end
    return mod
  end
  return require(name)
end
require = require_impl

do
local Enums = {}
Enums.LuaVersion = { LuaU = "LuaU", Lua51 = "Lua51" }
Enums.Conventions = {
  [Enums.LuaVersion.Lua51] = {
    Keywords = { "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while" },
    SymbolChars = { "+", "-", "*", "/", "%", "^", "#", "=", "~", "<", ">", "(", ")", "{", "}", "[", "]", ";", ":", ",", "." },
    MaxSymbolLength = 3,
    Symbols = { "+", "-", "*", "/", "%", "^", "#", "==", "~=", "<=", ">=", "<", ">", "=", "(", ")", "{", "}", "[", "]", ";", ":", ",", ".", "..", "..." },
    IdentChars = { "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","_","0","1","2","3","4","5","6","7","8","9" },
    NumberChars = { "0","1","2","3","4","5","6","7","8","9" },
    HexNumberChars = { "0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","A","B","C","D","E","F" },
    BinaryNumberChars = { "0","1" },
    DecimalExponent = { "e", "E" },
    HexadecimalNums = { "x", "X" },
    BinaryNums = { "b", "B" },
    DecimalSeperators = false,
    EscapeSequences = { ["a"] = "\\a", ["b"] = "\\b", ["f"] = "\\f", ["n"] = "\\n", ["r"] = "\\r", ["t"] = "\\t", ["v"] = "\\v", ["\\\\"] = "\\\\", ['"'] = '"', ["'"] = "'" },
    NumericalEscapes = true,
    EscapeZIgnoreNextWhitespace = true,
    HexEscapes = true,
    UnicodeEscapes = true,
  },
  [Enums.LuaVersion.LuaU] = {
    Keywords = { "and", "break", "do", "else", "elseif", "continue", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while" },
    SymbolChars = { "+", "-", "*", "/", "%", "^", "#", "=", "~", "<", ">", "(", ")", "{", "}", "[", "]", ";", ":", ",", ".", "?", "|", "&" },
    MaxSymbolLength = 3,
    Symbols = { "+", "-", "*", "/", "%", "^", "#", "==", "~=", "<=", ">=", "<", ">", "=", "+=", "-=", "/=", "%=", "^=", "..=", "*=", "(", ")", "{", "}", "[", "]", ";", ":", ",", ".", "..", "...", "::", "->", "?", "|", "&" },
    IdentChars = { "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","_","0","1","2","3","4","5","6","7","8","9" },
    NumberChars = { "0","1","2","3","4","5","6","7","8","9" },
    HexNumberChars = { "0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","A","B","C","D","E","F" },
    BinaryNumberChars = { "0","1" },
    DecimalExponent = { "e", "E" },
    HexadecimalNums = { "x", "X" },
    BinaryNums = { "b", "B" },
    DecimalSeperators = { "_" },
    EscapeSequences = { ["a"] = "\\a", ["b"] = "\\b", ["f"] = "\\f", ["n"] = "\\n", ["r"] = "\\r", ["t"] = "\\t", ["v"] = "\\v", ["\\\\"] = "\\\\", ['"'] = '"', ["'"] = "'" },
    NumericalEscapes = true,
    EscapeZIgnoreNextWhitespace = true,
    HexEscapes = true,
    UnicodeEscapes = true,
  },
}
_MODULES["prometheus.enums"] = function() return Enums end
end

do
local util = {}
function util.lookupify(tb) local res={} for _,v in ipairs(tb) do res[v]=true end return res end
function util.unlookupify(tb) local res={} for v,_ in pairs(tb) do table.insert(res,v) end return res end
function util.escape(str) return str:gsub(".", function(c) local b=string.byte(c) if b>=32 and b<=126 and c~="\\\\" and c~='"' and c~="'" then return c end if c=="\\\\" then return "\\\\\\\\" end if c=="\\n" then return "\\\\n" end if c=="\\r" then return "\\\\r" end if c=='"' then return '\\\\"' end if c=="'" then return "\\\\'" end return string.format("\\\\%03d", b) end) end
function util.chararray(str) local t={} for i=1,#str do t[i]=str:sub(i,i) end return t end
function util.keys(t) local k={} for kk,_ in pairs(t) do table.insert(k,kk) end return k end
function util.shuffle(t) for i=#t,2,-1 do local j=math.random(i) t[i],t[j]=t[j],t[i] end return t end
function util.readonly(obj) local p=newproxy(true) getmetatable(p).__index=obj return p end
local function utf8char(cp) if cp<128 then return string.char(cp) end local suffix=cp%64 local c4=128+suffix cp=(cp-suffix)/64 if cp<32 then return string.char(192+cp,c4) end suffix=cp%64 local c3=128+suffix cp=(cp-suffix)/64 if cp<16 then return string.char(224+cp,c3,c4) end suffix=cp%64 cp=(cp-suffix)/64 return string.char(240+cp,128+suffix,c3,c4) end
util.utf8char = utf8char
_MODULES["prometheus.util"] = function() return util end
end

do
local config = {
    IdentPrefix = "____",
    Debug = false,
}
_MODULES["config"] = function() return config end
end

do
local logger = {}
function logger.info(msg) if require("config").Debug then print("[INFO] " .. msg) end end
function logger.warn(msg) print("[WARN] " .. msg) end
function logger.error(msg) error("[ERROR] " .. msg, 2) end
_MODULES["logger"] = function() return logger end
end

do
local Ast = {}
local AstKind = {
  TopNode="TopNode", Block="Block", ContinueStatement="ContinueStatement", BreakStatement="BreakStatement",
  DoStatement="DoStatement", WhileStatement="WhileStatement", ReturnStatement="ReturnStatement",
  RepeatStatement="RepeatStatement", ForInStatement="ForInStatement", ForStatement="ForStatement",
  IfStatement="IfStatement", FunctionDeclaration="FunctionDeclaration", LocalFunctionDeclaration="LocalFunctionDeclaration",
  LocalVariableDeclaration="LocalVariableDeclaration", FunctionCallStatement="FunctionCallStatement",
  PassSelfFunctionCallStatement="PassSelfFunctionCallStatement", AssignmentStatement="AssignmentStatement",
  CompoundAddStatement="CompoundAddStatement", CompoundSubStatement="CompoundSubStatement",
  CompoundMulStatement="CompoundMulStatement", CompoundDivStatement="CompoundDivStatement",
  CompoundModStatement="CompoundModStatement", CompoundPowStatement="CompoundPowStatement",
  CompoundConcatStatement="CompoundConcatStatement", AssignmentIndexing="AssignmentIndexing",
  AssignmentVariable="AssignmentVariable", BooleanExpression="BooleanExpression", NumberExpression="NumberExpression",
  StringExpression="StringExpression", NilExpression="NilExpression", VarargExpression="VarargExpression",
  OrExpression="OrExpression", AndExpression="AndExpression", LessThanExpression="LessThanExpression",
  GreaterThanExpression="GreaterThanExpression", LessThanOrEqualsExpression="LessThanOrEqualsExpression",
  GreaterThanOrEqualsExpression="GreaterThanOrEqualsExpression", NotEqualsExpression="NotEqualsExpression",
  EqualsExpression="EqualsExpression", StrCatExpression="StrCatExpression", AddExpression="AddExpression",
  SubExpression="SubExpression", MulExpression="MulExpression", DivExpression="DivExpression",
  ModExpression="ModExpression", NotExpression="NotExpression", LenExpression="LenExpression",
  NegateExpression="NegateExpression", PowExpression="PowExpression", IndexExpression="IndexExpression",
  FunctionCallExpression="FunctionCallExpression", PassSelfFunctionCallExpression="PassSelfFunctionCallExpression",
  VariableExpression="VariableExpression", FunctionLiteralExpression="FunctionLiteralExpression",
  TableConstructorExpression="TableConstructorExpression", TableEntry="TableEntry", KeyedTableEntry="KeyedTableEntry",
  NopStatement="NopStatement", IfElseExpression="IfElseExpression",
}
Ast.AstKind = AstKind
local exprPriority = {
  [AstKind.BooleanExpression]=0, [AstKind.NumberExpression]=0, [AstKind.StringExpression]=0,
  [AstKind.NilExpression]=0, [AstKind.VarargExpression]=0, [AstKind.OrExpression]=12,
  [AstKind.AndExpression]=11, [AstKind.LessThanExpression]=10, [AstKind.GreaterThanExpression]=10,
  [AstKind.LessThanOrEqualsExpression]=10, [AstKind.GreaterThanOrEqualsExpression]=10,
  [AstKind.NotEqualsExpression]=10, [AstKind.EqualsExpression]=10, [AstKind.StrCatExpression]=9,
  [AstKind.AddExpression]=8, [AstKind.SubExpression]=8, [AstKind.MulExpression]=7,
  [AstKind.DivExpression]=7, [AstKind.ModExpression]=7, [AstKind.NotExpression]=5,
  [AstKind.LenExpression]=5, [AstKind.NegateExpression]=5, [AstKind.PowExpression]=4,
  [AstKind.IndexExpression]=1, [AstKind.AssignmentIndexing]=1, [AstKind.FunctionCallExpression]=2,
  [AstKind.PassSelfFunctionCallExpression]=2, [AstKind.VariableExpression]=0, [AstKind.AssignmentVariable]=0,
  [AstKind.FunctionLiteralExpression]=3, [AstKind.TableConstructorExpression]=3,
}
function Ast.astKindExpressionToNumber(k) return exprPriority[k] or 100 end
function Ast.ConstantNode(v) if v==nil then return Ast.NilExpression() end if type(v)=="string" then return Ast.StringExpression(v) end if type(v)=="number" then return Ast.NumberExpression(v) end if type(v)=="boolean" then return Ast.BooleanExpression(v) end end
function Ast.NopStatement() return {kind=AstKind.NopStatement} end
function Ast.IfElseExpression(c,t,e,f) return {kind=AstKind.IfElseExpression, condition=c, true_value=t, elseifs=e, false_value=f} end
function Ast.TopNode(b,gs) return {kind=AstKind.TopNode, body=b, globalScope=gs} end
function Ast.TableEntry(v) return {kind=AstKind.TableEntry, value=v} end
function Ast.KeyedTableEntry(k,v) return {kind=AstKind.KeyedTableEntry, key=k, value=v} end
function Ast.TableConstructorExpression(e) return {kind=AstKind.TableConstructorExpression, entries=e} end
function Ast.Block(s,sc) return {kind=AstKind.Block, statements=s, scope=sc} end
function Ast.BreakStatement(l,sc) return {kind=AstKind.BreakStatement, loop=l, scope=sc} end
function Ast.ContinueStatement(l,sc) return {kind=AstKind.ContinueStatement, loop=l, scope=sc} end
function Ast.PassSelfFunctionCallStatement(b,n,a) return {kind=AstKind.PassSelfFunctionCallStatement, base=b, passSelfFunctionName=n, args=a} end
function Ast.AssignmentStatement(l,r) return {kind=AstKind.AssignmentStatement, lhs=l, rhs=r} end
function Ast.CompoundAddStatement(l,r) return {kind=AstKind.CompoundAddStatement, lhs=l, rhs=r} end
function Ast.CompoundSubStatement(l,r) return {kind=AstKind.CompoundSubStatement, lhs=l, rhs=r} end
function Ast.CompoundMulStatement(l,r) return {kind=AstKind.CompoundMulStatement, lhs=l, rhs=r} end
function Ast.CompoundDivStatement(l,r) return {kind=AstKind.CompoundDivStatement, lhs=l, rhs=r} end
function Ast.CompoundPowStatement(l,r) return {kind=AstKind.CompoundPowStatement, lhs=l, rhs=r} end
function Ast.CompoundModStatement(l,r) return {kind=AstKind.CompoundModStatement, lhs=l, rhs=r} end
function Ast.CompoundConcatStatement(l,r) return {kind=AstKind.CompoundConcatStatement, lhs=l, rhs=r} end
function Ast.FunctionCallStatement(b,a) return {kind=AstKind.FunctionCallStatement, base=b, args=a} end
function Ast.ReturnStatement(a) return {kind=AstKind.ReturnStatement, args=a} end
function Ast.DoStatement(b) return {kind=AstKind.DoStatement, body=b} end
function Ast.WhileStatement(b,c,p) return {kind=AstKind.WhileStatement, body=b, condition=c, parentScope=p} end
function Ast.ForInStatement(sc,v,e,b,p) return {kind=AstKind.ForInStatement, scope=sc, ids=v, vars=v, expressions=e, body=b, parentScope=p} end
function Ast.ForStatement(sc,id,iv,fv,inc,b,p) return {kind=AstKind.ForStatement, scope=sc, id=id, initialValue=iv, finalValue=fv, incrementBy=inc, body=b, parentScope=p} end
function Ast.RepeatStatement(c,b,p) return {kind=AstKind.RepeatStatement, body=b, condition=c, parentScope=p} end
function Ast.IfStatement(c,b,e,el) return {kind=AstKind.IfStatement, condition=c, body=b, elseifs=e, elsebody=el} end
function Ast.FunctionDeclaration(sc,id,ind,a,b) return {kind=AstKind.FunctionDeclaration, scope=sc, baseScope=sc, id=id, baseId=id, indices=ind, args=a, body=b, getName=function(self) return self.scope:getVariableName(self.id) end} end
function Ast.LocalFunctionDeclaration(sc,id,a,b) return {kind=AstKind.LocalFunctionDeclaration, scope=sc, id=id, args=a, body=b, getName=function(self) return self.scope:getVariableName(self.id) end} end
function Ast.LocalVariableDeclaration(sc,ids,e) return {kind=AstKind.LocalVariableDeclaration, scope=sc, ids=ids, expressions=e} end
function Ast.VarargExpression() return {kind=AstKind.VarargExpression, isConstant=false} end
function Ast.BooleanExpression(v) return {kind=AstKind.BooleanExpression, isConstant=true, value=v} end
function Ast.NilExpression() return {kind=AstKind.NilExpression, isConstant=true, value=nil} end
function Ast.NumberExpression(v) return {kind=AstKind.NumberExpression, isConstant=true, value=v} end
function Ast.StringExpression(v) return {kind=AstKind.StringExpression, isConstant=true, value=v} end
function Ast.OrExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value or r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.OrExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.AndExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value and r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.AndExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.LessThanExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value < r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.LessThanExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.GreaterThanExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value > r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.GreaterThanExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.LessThanOrEqualsExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value <= r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.LessThanOrEqualsExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.GreaterThanOrEqualsExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value >= r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.GreaterThanOrEqualsExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.NotEqualsExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value ~= r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.NotEqualsExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.EqualsExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value == r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.EqualsExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.StrCatExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value .. r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.StrCatExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.AddExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value + r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.AddExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.SubExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value - r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.SubExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.MulExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value * r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.MulExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.DivExpression(l,r,s) if s and r.isConstant and l.isConstant and r.value~=0 then local ok,val=pcall(function() return l.value / r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.DivExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.ModExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value % r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.ModExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.NotExpression(r,s) if s and r.isConstant then local ok,val=pcall(function() return not r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.NotExpression, rhs=r, isConstant=false} end
function Ast.NegateExpression(r,s) if s and r.isConstant then local ok,val=pcall(function() return -r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.NegateExpression, rhs=r, isConstant=false} end
function Ast.LenExpression(r,s) if s and r.isConstant then local ok,val=pcall(function() return #r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.LenExpression, rhs=r, isConstant=false} end
function Ast.PowExpression(l,r,s) if s and r.isConstant and l.isConstant then local ok,val=pcall(function() return l.value ^ r.value end) if ok then return Ast.ConstantNode(val) end end return {kind=AstKind.PowExpression, lhs=l, rhs=r, isConstant=false} end
function Ast.IndexExpression(b,i) return {kind=AstKind.IndexExpression, base=b, index=i, isConstant=false} end
function Ast.AssignmentIndexing(b,i) return {kind=AstKind.AssignmentIndexing, base=b, index=i, isConstant=false} end
function Ast.PassSelfFunctionCallExpression(b,n,a) return {kind=AstKind.PassSelfFunctionCallExpression, base=b, passSelfFunctionName=n, args=a} end
function Ast.FunctionCallExpression(b,a) return {kind=AstKind.FunctionCallExpression, base=b, args=a} end
function Ast.VariableExpression(sc,id) sc:addReference(id) return {kind=AstKind.VariableExpression, scope=sc, id=id, getName=function(self) return self.scope.getVariableName(self.id) end} end
function Ast.AssignmentVariable(sc,id) sc:addReference(id) return {kind=AstKind.AssignmentVariable, scope=sc, id=id, getName=function(self) return self.scope.getVariableName(self.id) end} end
function Ast.FunctionLiteralExpression(a,b) return {kind=AstKind.FunctionLiteralExpression, args=a, body=b} end
_MODULES["prometheus.ast"] = function() return Ast end
end

do
local Scope = {}
local config = require("config")
local function nextName() local i=0 return function() i=i+1 return "local_scope_"..i end end
local function generateWarning(token,msg) return "Warning at Position "..token.line..":"..token.linePos..", "..msg end
function Scope:new(parent,name) local s={isGlobal=false,parentScope=parent,variables={},referenceCounts={},variablesLookup={},variablesFromHigherScopes={},skipIdLookup={},name=name or nextName(),children={},level=parent.level and parent.level+1 or 1} setmetatable(s,self) self.__index=self parent:addChild(s) return s end
function Scope:newGlobal() local s={isGlobal=true,parentScope=nil,variables={},variablesLookup={},referenceCounts={},skipIdLookup={},name="global_scope",children={},level=0} setmetatable(s,self) self.__index=self return s end
function Scope:getParent() return self.parentScope end
function Scope:setParent(p) self.parentScope:removeChild(self) p:addChild(self) self.parentScope=p self.level=p.level+1 end
local next_name_i=1
function Scope:addVariable(name,token) if not name then name=config.IdentPrefix..next_name_i next_name_i=next_name_i+1 end if self.variablesLookup[name]~=nil then if token then logger:warn(generateWarning(token,"the variable \""..name.."\" is already defined in that scope")) else logger:error("A variable with the name \""..name.."\" was already defined") end end table.insert(self.variables,name) local id=#self.variables self.variablesLookup[name]=id return id end
function Scope:enableVariable(id) local name=self.variables[id] self.variablesLookup[name]=id end
function Scope:addDisabledVariable(name,token) if not name then name=config.IdentPrefix..next_name_i next_name_i=next_name_i+1 end if self.variablesLookup[name]~=nil then if token then logger:warn(generateWarning(token,"the variable \""..name.."\" is already defined in that scope")) else logger:warn("a variable with the name \""..name.."\" was already defined") end end table.insert(self.variables,name) local id=#self.variables return id end
function Scope:addIfNotExists(id) if not self.variables[id] then local name=config.IdentPrefix..next_name_i next_name_i=next_name_i+1 self.variables[id]=name self.variablesLookup[name]=id end return id end
function Scope:hasVariable(name) if self.isGlobal then if self.variablesLookup[name]==nil then self:addVariable(name) end return true end return self.variablesLookup[name]~=nil end
function Scope:getVariables() return self.variables end
function Scope:resetReferences(id) self.referenceCounts[id]=0 end
function Scope:getReferences(id) return self.referenceCounts[id] or 0 end
function Scope:removeReference(id) self.referenceCounts[id]=(self.referenceCounts[id] or 0)-1 end
function Scope:addReference(id) self.referenceCounts[id]=(self.referenceCounts[id] or 0)+1 end
function Scope:resolve(name) if self:hasVariable(name) then return self,self.variablesLookup[name] end assert(self.parentScope,"No Global Variable Scope was Created!") local scope,id=self.parentScope:resolve(name) self:addReferenceToHigherScope(scope,id,nil,true) return scope,id end
function Scope:resolveGlobal(name) if self.isGlobal and self:hasVariable(name) then return self,self.variablesLookup[name] end assert(self.parentScope,"No Global Variable Scope was Created!") local scope,id=self.parentScope:resolveGlobal(name) self:addReferenceToHigherScope(scope,id,nil,true) return scope,id end
function Scope:getVariableName(id) return self.variables[id] end
function Scope:removeVariable(id) local name=self.variables[id] self.variables[id]=nil self.variablesLookup[name]=nil self.skipIdLookup[id]=true end
function Scope:addChild(scope) for sc,ids in pairs(scope.variablesFromHigherScopes) do for id,count in pairs(ids) do if count and count>0 then self:addReferenceToHigherScope(sc,id,count) end end end table.insert(self.children,scope) end
function Scope:clearReferences() self.referenceCounts={} self.variablesFromHigherScopes={} end
function Scope:removeChild(child) for i,v in ipairs(self.children) do if v==child then for sc,ids in pairs(v.variablesFromHigherScopes) do for id,count in pairs(ids) do if count and count>0 then self:removeReferenceToHigherScope(sc,id,count) end end end return table.remove(self.children,i) end end end
function Scope:getMaxId() return #self.variables end
function Scope:addReferenceToHigherScope(scope,id,n,b) n=n or 1 if self.isGlobal then if not scope.isGlobal then logger:error("Could not resolve Scope \""..scope.name.."\"") end return end if scope==self then self.referenceCounts[id]=(self.referenceCounts[id] or 0)+n return end if not self.variablesFromHigherScopes[scope] then self.variablesFromHigherScopes[scope]={} end local sr=self.variablesFromHigherScopes[scope] if sr[id] then sr[id]=sr[id]+n else sr[id]=n end if not b then self.parentScope:addReferenceToHigherScope(scope,id,n) end end
function Scope:removeReferenceToHigherScope(scope,id,n,b) n=n or 1 if self.isGlobal then return end if scope==self then self.referenceCounts[id]=(self.referenceCounts[id] or 0)-n return end if not self.variablesFromHigherScopes[scope] then self.variablesFromHigherScopes[scope]={} end local sr=self.variablesFromHigherScopes[scope] if sr[id] then sr[id]=sr[id]-n else sr[id]=0 end if not b then self.parentScope:removeReferenceToHigherScope(scope,id,n) end end
function Scope:renameVariables(settings) if not self.isGlobal then local prefix=settings.prefix or "" local forbidden={} for _,kw in pairs(settings.Keywords) do forbidden[kw]=true end for sc,ids in pairs(self.variablesFromHigherScopes) do for id,count in pairs(ids) do if count and count>0 then local name=sc:getVariableName(id) forbidden[name]=true end end end self.variablesLookup={} local i=0 for id,orig in pairs(self.variables) do if not self.skipIdLookup[id] and (self.referenceCounts[id] or 0)>=0 then local name repeat name=prefix..settings.generateName(i,self,orig) if name==nil then name=orig end i=i+1 until not forbidden[name] self.variables[id]=name self.variablesLookup[name]=id end end end for _,sc in pairs(self.children) do sc:renameVariables(settings) end end
_MODULES["prometheus.scope"] = function() return Scope end
end

do
local Tokenizer = {}
local Enums = require("prometheus.enums")
local util = require("prometheus.util")
local logger = require("logger")
local config = require("config")
local LuaVersion = Enums.LuaVersion
local lookupify = util.lookupify
local unlookupify = util.unlookupify
local escape = util.escape
local chararray = util.chararray
local keys = util.keys
Tokenizer.EOF_CHAR = "<EOF>"
Tokenizer.WHITESPACE_CHARS = lookupify{" ","\\t","\\n","\\r"}
Tokenizer.ANNOTATION_CHARS = lookupify(chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"))
Tokenizer.ANNOTATION_START_CHARS = lookupify{"!","@"}
Tokenizer.Conventions = Enums.Conventions
Tokenizer.TokenKind = { Eof="Eof", Keyword="Keyword", Symbol="Symbol", Ident="Identifier", Number="Number", String="String" }
Tokenizer.EOF_TOKEN = { kind=Tokenizer.TokenKind.Eof, value="<EOF>", startPos=-1, endPos=-1, source="<EOF>" }
local function token(self,sp,kind,value) local line,linePos=self:getPosition(self.index) local ann=self.annotations self.annotations={} return { kind=kind, value=value, startPos=sp, endPos=self.index, source=self.source:sub(sp+1,self.index), line=line, linePos=linePos, annotations=ann } end
local function generateError(self,msg) local line,linePos=self:getPosition(self.index) return "Lexing Error at Position "..line..":"..linePos..", "..msg end
local function generateWarning(token,msg) return "Warning at Position "..token.line..":"..token.linePos..", "..msg end
function Tokenizer:getPosition(i) local col=self.columnMap[i] if not col then col=self.columnMap[#self.columnMap] end return col.id, col.charMap[i] end
function Tokenizer:prepareGetPosition() local colMap, col = {}, { charMap={}, id=1, length=0 } for idx=1,self.length do local c=self.source:sub(idx,idx) local colLen=col.length+1 col.length=colLen col.charMap[idx]=colLen if c=="\\n" then col={ charMap={}, id=col.id+1, length=0 } end colMap[idx]=col end self.columnMap=colMap end
function Tokenizer:new(settings) local lv=(settings and (settings.luaVersion or settings.LuaVersion)) or LuaVersion.LuaU local conv=Tokenizer.Conventions[lv] if not conv then logger:error("The Lua Version \""..lv.."\" is not recognized by the Tokenizer!") end local t={ index=0, length=0, source="", luaVersion=lv, conventions=conv, NumberChars=conv.NumberChars, NumberCharsLookup=lookupify(conv.NumberChars), Keywords=conv.Keywords, KeywordsLookup=lookupify(conv.Keywords), BinaryNumberChars=conv.BinaryNumberChars, BinaryNumberCharsLookup=lookupify(conv.BinaryNumberChars), BinaryNums=conv.BinaryNums, HexadecimalNums=conv.HexadecimalNums, HexNumberChars=conv.HexNumberChars, HexNumberCharsLookup=lookupify(conv.HexNumberChars), DecimalExponent=conv.DecimalExponent, DecimalSeperators=conv.DecimalSeperators, IdentChars=conv.IdentChars, IdentCharsLookup=lookupify(conv.IdentChars), EscapeSequences=conv.EscapeSequences, NumericalEscapes=conv.NumericalEscapes, EscapeZIgnoreNextWhitespace=conv.EscapeZIgnoreNextWhitespace, HexEscapes=conv.HexEscapes, UnicodeEscapes=conv.UnicodeEscapes, SymbolChars=conv.SymbolChars, SymbolCharsLookup=lookupify(conv.SymbolChars), MaxSymbolLength=conv.MaxSymbolLength, Symbols=conv.Symbols, SymbolsLookup=lookupify(conv.Symbols), StringStartLookup=lookupify{"\"","'"}, annotations={} } setmetatable(t,self) self.__index=self return t end
function Tokenizer:reset() self.index=0 self.length=0 self.source="" self.annotations={} self.columnMap={} end
function Tokenizer:append(code) self.source=self.source..code self.length=self.length+#code self:prepareGetPosition() end
local function peek(self,n) n=n or 0 local i=self.index+n+1 if i>self.length then return Tokenizer.EOF_CHAR end return self.source:sub(i,i) end
local function get(self) local i=self.index+1 if i>self.length then logger:error(generateError(self,"Unexpected end of Input")) end self.index=self.index+1 return self.source:sub(i,i) end
local function expect(self,lookup) if type(lookup)=="string" then lookup={[lookup]=true} end local c=peek(self) if not lookup[c] then local tb=unlookupify(lookup) for i,v in ipairs(tb) do tb[i]=escape(v) end logger:error(generateError(self,"Unexpected char \""..escape(c).."\"! Expected one of \""..table.concat(tb,"\",\"").."\"")) end self.index=self.index+1 return c end
local function is(self,lookup,n) local c=peek(self,n) if type(lookup)=="string" then return c==lookup end return lookup[c] end
function Tokenizer:parseAnnotation() if is(self,Tokenizer.ANNOTATION_START_CHARS) then self.index=self.index+1 local src={} local len=0 while is(self,Tokenizer.ANNOTATION_CHARS) do table.insert(src,get(self)) end if #src>0 then self.annotations[string.lower(table.concat(src))]=true end return nil end return get(self) end
function Tokenizer:skipComment() if is(self,"-",0) and is(self,"-",1) then self.index=self.index+2 if is(self,"[") then self.index=self.index+1 local eq=0 while is(self,"=") do self.index=self.index+1 eq=eq+1 end if is(self,"[") then while true do if self:parseAnnotation()=="]" then local eq2=0 while is(self,"=") do self.index=self.index+1 eq2=eq2+1 end if is(self,"]") then if eq2==eq then self.index=self.index+1 return true end end end end end end while self.index<self.length and self:parseAnnotation()~="\\n" do end return true end return false end
function Tokenizer:skipWhitespaceAndComments() while self:skipComment() do end while is(self,Tokenizer.WHITESPACE_CHARS) do self.index=self.index+1 while self:skipComment() do end end end
local function int(self,chars,seps) local buf={} while true do if is(self,chars) then table.insert(buf,get(self)) elseif is(self,seps) then self.index=self.index+1 else break end end return table.concat(buf) end
function Tokenizer:number() local sp=self.index local src=expect(self,setmetatable({["."]=true},{__index=self.NumberCharsLookup})) if src=="0" then if self.BinaryNums and is(self,lookupify(self.BinaryNums)) then self.index=self.index+1 src=int(self,self.BinaryNumberCharsLookup,lookupify(self.DecimalSeperators or {})) return token(self,sp,Tokenizer.TokenKind.Number,tonumber(src,2)) end if self.HexadecimalNums and is(self,lookupify(self.HexadecimalNums)) then self.index=self.index+1 src=int(self,self.HexNumberCharsLookup,lookupify(self.DecimalSeperators or {})) return token(self,sp,Tokenizer.TokenKind.Number,tonumber(src,16)) end end if src=="." then src=src..int(self,self.NumberCharsLookup,lookupify(self.DecimalSeperators or {})) else src=src..int(self,self.NumberCharsLookup,lookupify(self.DecimalSeperators or {})) if is(self,".") then src=src..get(self)..int(self,self.NumberCharsLookup,lookupify(self.DecimalSeperators or {})) end end if self.DecimalExponent and is(self,lookupify(self.DecimalExponent)) then src=src..get(self) if is(self,lookupify{"+","-"}) then src=src..get(self) end local v=int(self,self.NumberCharsLookup,lookupify(self.DecimalSeperators or {})) if #v<1 then logger:error(generateError(self,"Expected a Valid Exponent!")) end src=src..v end return token(self,sp,Tokenizer.TokenKind.Number,tonumber(src)) end
function Tokenizer:ident() local sp=self.index local src=expect(self,self.IdentCharsLookup) local parts={src} while is(self,self.IdentCharsLookup) do table.insert(parts,get(self)) end src=table.concat(parts) if self.KeywordsLookup[src] then return token(self,sp,Tokenizer.TokenKind.Keyword,src) end local tk=token(self,sp,Tokenizer.TokenKind.Ident,src) if string.sub(src,1,#config.IdentPrefix)==config.IdentPrefix then logger:warn(generateWarning(tk,"identifiers should not start with \""..config.IdentPrefix.."\"")) end return tk end
function Tokenizer:singleLineString() local sp=self.index local start=expect(self,self.StringStartLookup) local buf={} while not is(self,start) do local c=get(self) if c=="\\n" then self.index=self.index-1 logger:error(generateError(self,"Unterminated String")) end if c=="\\\\" then c=get(self) local esc=self.EscapeSequences[c] if type(esc)=="string" then c=esc elseif self.NumericalEscapes and self.NumberCharsLookup[c] then local num=c if is(self,self.NumberCharsLookup) then num=num..get(self) end if is(self,self.NumberCharsLookup) then num=num..get(self) end c=string.char(tonumber(num)) elseif self.UnicodeEscapes and c=="u" then expect(self,"{") local num="" while is(self,self.HexNumberCharsLookup) do num=num..get(self) end expect(self,"}") c=util.utf8char(tonumber(num,16)) elseif self.HexEscapes and c=="x" then local hex=expect(self,self.HexNumberCharsLookup)..expect(self,self.HexNumberCharsLookup) c=string.char(tonumber(hex,16)) elseif self.EscapeZIgnoreNextWhitespace and c=="z" then c="" while is(self,Tokenizer.WHITESPACE_CHARS) do self.index=self.index+1 end end end table.insert(buf,c) end expect(self,start) return token(self,sp,Tokenizer.TokenKind.String,table.concat(buf)) end
function Tokenizer:multiLineString() local sp=self.index if is(self,"[") then self.index=self.index+1 local eq=0 while is(self,"=") do self.index=self.index+1 eq=eq+1 end if is(self,"[") then self.index=self.index+1 if is(self,"\\n") then self.index=self.index+1 end local val="" while true do local c=get(self) if c=="]" then local eq2=0 while is(self,"=") do c=c..get(self) eq2=eq2+1 end if is(self,"]") then if eq2==eq then self.index=self.index+1 return token(self,sp,Tokenizer.TokenKind.String,val), true end end end val=val..c end end end self.index=sp return nil,false end
function Tokenizer:symbol() local sp=self.index for len=self.MaxSymbolLength,1,-1 do local str=self.source:sub(self.index+1,self.index+len) if self.SymbolsLookup[str] then self.index=self.index+len return token(self,sp,Tokenizer.TokenKind.Symbol,str) end end logger:error(generateError(self,"Unknown Symbol")) end
function Tokenizer:next() self:skipWhitespaceAndComments() local sp=self.index if sp>=self.length then return token(self,sp,Tokenizer.TokenKind.Eof) end if is(self,self.NumberCharsLookup) then return self:number() end if is(self,self.IdentCharsLookup) then return self:ident() end if is(self,self.StringStartLookup) then return self:singleLineString() end if is(self,"[",0) then local val,isStr=self:multiLineString() if isStr then return val end end if is(self,".") and is(self,self.NumberCharsLookup,1) then return self:number() end if is(self,self.SymbolCharsLookup) then return self:symbol() end logger:error(generateError(self,"Unexpected char \""..escape(peek(self)).."\"")) end
function Tokenizer:scanAll() local tb={} repeat local tok=self:next() table.insert(tb,tok) until tok.kind==Tokenizer.TokenKind.Eof return tb end
_MODULES["prometheus.tokenizer"] = function() return Tokenizer end
end

do
local Parser = {}
local Ast = require("prometheus.ast")
local AstKind = Ast.AstKind
local Scope = require("prometheus.scope")
local Tokenizer = require("prometheus.tokenizer")
local config = require("config")
local logger = require("logger")

function Parser:new(tokenizer, settings)
    local p = {
        tokenizer = tokenizer,
        settings = settings or {},
        globalScope = Scope:newGlobal(),
        currentScope = nil,
        currentLoop = nil,
        current = nil,
        nextTok = nil,
    }
    p.currentScope = p.globalScope
    p.current = tokenizer:next()
    p.nextTok = tokenizer:next()
    setmetatable(p, {__index = Parser})
    return p
end

function Parser:advance()
    self.current = self.nextTok
    self.nextTok = self.tokenizer:next()
end

function Parser:peek()
    return self.nextTok
end

function Parser:expect(kind, value)
    if self.current.kind == kind and (value == nil or self.current.value == value) then
        local tok = self.current
        self:advance()
        return tok
    end
    logger:error(string.format("Expected %s %s, got %s %s at line %d:%d",
        kind, value or "", self.current.kind, self.current.value or "", self.current.line, self.current.linePos))
end

function Parser:parse()
    local body = self:parseBlock({ ["Eof"] = true })
    return Ast.TopNode(body, self.globalScope)
end

function Parser:parseBlock(stopTokens)
    local statements = {}
    while true do
        local tok = self.current
        if stopTokens[tok.kind] or (tok.kind == "Keyword" and stopTokens[tok.value]) then
            break
        end
        local stmt = self:parseStatement()
        if stmt then
            table.insert(statements, stmt)
        end
    end
    return Ast.Block(statements, self.currentScope)
end

function Parser:parseStatement()
    local tok = self.current
    if tok.kind == "Keyword" then
        local kw = tok.value
        if kw == "if" then return self:parseIfStatement()
        elseif kw == "while" then return self:parseWhileStatement()
        elseif kw == "repeat" then return self:parseRepeatStatement()
        elseif kw == "for" then return self:parseForStatement()
        elseif kw == "function" then return self:parseFunctionDeclaration()
        elseif kw == "local" then return self:parseLocalDeclaration()
        elseif kw == "return" then return self:parseReturnStatement()
        elseif kw == "break" then self:advance(); return Ast.BreakStatement(self.currentLoop, self.currentScope)
        elseif kw == "continue" then self:advance(); return Ast.ContinueStatement(self.currentLoop, self.currentScope)
        elseif kw == "do" then return self:parseDoStatement()
        else logger:error("Unexpected keyword " .. kw)
        end
    elseif tok.kind == "Symbol" and tok.value == "::" then
        return self:parseLabel()
    elseif tok.kind == "Symbol" and tok.value == ";" then
        self:advance()
        return nil
    else
        return self:parseAssignmentOrCallStatement()
    end
end

function Parser:parseIfStatement()
    self:expect("Keyword", "if")
    local condition = self:parseExpression()
    self:expect("Keyword", "then")
    local body = self:parseBlock({ ["end"] = true, ["else"] = true, ["elseif"] = true })
    local elseifs = {}
    while self.current.kind == "Keyword" and self.current.value == "elseif" do
        self:advance()
        local elseifCond = self:parseExpression()
        self:expect("Keyword", "then")
        local elseifBody = self:parseBlock({ ["end"] = true, ["else"] = true, ["elseif"] = true })
        table.insert(elseifs, { condition = elseifCond, body = elseifBody })
    end
    local elseBody = nil
    if self.current.kind == "Keyword" and self.current.value == "else" then
        self:advance()
        elseBody = self:parseBlock({ ["end"] = true })
    end
    self:expect("Keyword", "end")
    return Ast.IfStatement(condition, body, elseifs, elseBody)
end

function Parser:parseWhileStatement()
    self:expect("Keyword", "while")
    local condition = self:parseExpression()
    self:expect("Keyword", "do")
    local oldLoop = self.currentLoop
    self.currentLoop = "while"
    local body = self:parseBlock({ ["end"] = true })
    self:expect("Keyword", "end")
    self.currentLoop = oldLoop
    return Ast.WhileStatement(body, condition, self.currentScope)
end

function Parser:parseRepeatStatement()
    self:expect("Keyword", "repeat")
    local oldLoop = self.currentLoop
    self.currentLoop = "repeat"
    local body = self:parseBlock({ ["until"] = true })
    self:expect("Keyword", "until")
    local condition = self:parseExpression()
    self.currentLoop = oldLoop
    return Ast.RepeatStatement(condition, body, self.currentScope)
end

function Parser:parseForStatement()
    self:expect("Keyword", "for")
    local firstName = self:expect("Ident").value
    if self.current.kind == "Symbol" and self.current.value == "=" then
        self:advance()
        local init = self:parseExpression()
        self:expect("Symbol", ",")
        local limit = self:parseExpression()
        local step = nil
        if self.current.kind == "Symbol" and self.current.value == "," then
            self:advance()
            step = self:parseExpression()
        end
        self:expect("Keyword", "do")
        local newScope = Scope:new(self.currentScope)
        local id = newScope:addVariable(firstName)
        self.currentScope = newScope
        local oldLoop = self.currentLoop
        self.currentLoop = "for"
        local body = self:parseBlock({ ["end"] = true })
        self:expect("Keyword", "end")
        self.currentScope = newScope:getParent()
        self.currentLoop = oldLoop
        return Ast.ForStatement(newScope, id, init, limit, step or Ast.NumberExpression(1), body, self.currentScope)
    else
        local names = { firstName }
        while self.current.kind == "Symbol" and self.current.value == "," do
            self:advance()
            table.insert(names, self:expect("Ident").value)
        end
        self:expect("Keyword", "in")
        local exprs = { self:parseExpression() }
        while self.current.kind == "Symbol" and self.current.value == "," do
            self:advance()
            table.insert(exprs, self:parseExpression())
        end
        self:expect("Keyword", "do")
        local newScope = Scope:new(self.currentScope)
        local ids = {}
        for _, n in ipairs(names) do
            table.insert(ids, newScope:addVariable(n))
        end
        self.currentScope = newScope
        local oldLoop = self.currentLoop
        self.currentLoop = "forin"
        local body = self:parseBlock({ ["end"] = true })
        self:expect("Keyword", "end")
        self.currentScope = newScope:getParent()
        self.currentLoop = oldLoop
        return Ast.ForInStatement(newScope, ids, exprs, body, self.currentScope)
    end
end

function Parser:parseFunctionDeclaration()
    self:expect("Keyword", "function")
    local baseName = self:expect("Ident").value
    local scope, baseId = self.currentScope:resolve(baseName)
    local indices = {}
    while self.current.kind == "Symbol" and self.current.value == "." do
        self:advance()
        table.insert(indices, self:expect("Ident").value)
    end
    local methodName = nil
    if self.current.kind == "Symbol" and self.current.value == ":" then
        self:advance()
        methodName = self:expect("Ident").value
    end
    self:expect("Symbol", "(")
    local args = self:parseFunctionArgs()
    self:expect("Symbol", ")")
    local body, funcScope = self:parseFunctionBody(args)
    self:expect("Keyword", "end")
    return Ast.FunctionDeclaration(scope, baseId, indices, args, body)
end

function Parser:parseLocalDeclaration()
    self:expect("Keyword", "local")
    if self.current.kind == "Keyword" and self.current.value == "function" then
        self:advance()
        local name = self:expect("Ident").value
        self:expect("Symbol", "(")
        local args = self:parseFunctionArgs()
        self:expect("Symbol", ")")
        local body, funcScope = self:parseFunctionBody(args)
        self:expect("Keyword", "end")
        local id = self.currentScope:addVariable(name)
        return Ast.LocalFunctionDeclaration(self.currentScope, id, args, body)
    else
        local names = { self:expect("Ident").value }
        while self.current.kind == "Symbol" and self.current.value == "," do
            self:advance()
            table.insert(names, self:expect("Ident").value)
        end
        local exprs = {}
        if self.current.kind == "Symbol" and self.current.value == "=" then
            self:advance()
            table.insert(exprs, self:parseExpression())
            while self.current.kind == "Symbol" and self.current.value == "," do
                self:advance()
                table.insert(exprs, self:parseExpression())
            end
        end
        local ids = {}
        for _, n in ipairs(names) do
            table.insert(ids, self.currentScope:addVariable(n))
        end
        return Ast.LocalVariableDeclaration(self.currentScope, ids, exprs)
    end
end

function Parser:parseReturnStatement()
    self:expect("Keyword", "return")
    local args = {}
    local stop = { ["end"] = true, ["until"] = true, ["else"] = true, ["elseif"] = true, Eof = true }
    if not stop[self.current.kind] and not (self.current.kind == "Keyword" and stop[self.current.value]) then
        table.insert(args, self:parseExpression())
        while self.current.kind == "Symbol" and self.current.value == "," do
            self:advance()
            table.insert(args, self:parseExpression())
        end
    end
    return Ast.ReturnStatement(args)
end

function Parser:parseDoStatement()
    self:expect("Keyword", "do")
    local body = self:parseBlock({ ["end"] = true })
    self:expect("Keyword", "end")
    return Ast.DoStatement(body)
end

function Parser:parseLabel()
    self:expect("Symbol", "::")
    self:expect("Ident")
    self:expect("Symbol", "::")
    return Ast.NopStatement()
end

function Parser:parseAssignmentOrCallStatement()
    local lhs = {}
    local firstExpr = self:parsePrimary(true)
    if (firstExpr.kind == AstKind.FunctionCallExpression or firstExpr.kind == AstKind.PassSelfFunctionCallExpression)
        and not self:isAssignmentOperator() then
        if firstExpr.kind == AstKind.PassSelfFunctionCallExpression then
            return Ast.PassSelfFunctionCallStatement(firstExpr.base, firstExpr.passSelfFunctionName, firstExpr.args)
        else
            return Ast.FunctionCallStatement(firstExpr.base, firstExpr.args)
        end
    end
    table.insert(lhs, firstExpr)
    while self.current.kind == "Symbol" and self.current.value == "," do
        self:advance()
        table.insert(lhs, self:parsePrimary(true))
    end
    local op = self.current.value
    if op == "=" then
        self:advance()
        local rhs = { self:parseExpression() }
        while self.current.kind == "Symbol" and self.current.value == "," do
            self:advance()
            table.insert(rhs, self:parseExpression())
        end
        local assignLhs = {}
        for _, node in ipairs(lhs) do
            if node.kind == AstKind.VariableExpression then
                table.insert(assignLhs, Ast.AssignmentVariable(node.scope, node.id))
            elseif node.kind == AstKind.IndexExpression then
                table.insert(assignLhs, Ast.AssignmentIndexing(node.base, node.index))
            else
                logger:error("Invalid left-hand side in assignment")
            end
        end
        return Ast.AssignmentStatement(assignLhs, rhs)
    elseif op == "+=" then self:advance(); return Ast.CompoundAddStatement(self:convertLhs(lhs[1]), { self:parseExpression() })
    elseif op == "-=" then self:advance(); return Ast.CompoundSubStatement(self:convertLhs(lhs[1]), { self:parseExpression() })
    elseif op == "*=" then self:advance(); return Ast.CompoundMulStatement(self:convertLhs(lhs[1]), { self:parseExpression() })
    elseif op == "/=" then self:advance(); return Ast.CompoundDivStatement(self:convertLhs(lhs[1]), { self:parseExpression() })
    elseif op == "%=" then self:advance(); return Ast.CompoundModStatement(self:convertLhs(lhs[1]), { self:parseExpression() })
    elseif op == "^=" then self:advance(); return Ast.CompoundPowStatement(self:convertLhs(lhs[1]), { self:parseExpression() })
    elseif op == "..=" then self:advance(); return Ast.CompoundConcatStatement(self:convertLhs(lhs[1]), { self:parseExpression() })
    else
        logger:error("Unexpected token in statement: " .. op)
    end
end

function Parser:isAssignmentOperator()
    local t = self.current
    if t.kind == "Symbol" then
        local v = t.value
        return v == "=" or v == "+=" or v == "-=" or v == "*=" or v == "/=" or v == "%=" or v == "^=" or v == "..="
    end
    return false
end

function Parser:convertLhs(node)
    if node.kind == AstKind.VariableExpression then
        return Ast.AssignmentVariable(node.scope, node.id)
    elseif node.kind == AstKind.IndexExpression then
        return Ast.AssignmentIndexing(node.base, node.index)
    else
        logger:error("Invalid left-hand side")
    end
end

function Parser:parseExpression()
    return self:parseOr()
end

function Parser:parseOr()
    local left = self:parseAnd()
    while self.current.kind == "Keyword" and self.current.value == "or" do
        self:advance()
        local right = self:parseAnd()
        left = Ast.OrExpression(left, right, self.settings.SimplifyConstants)
    end
    return left
end

function Parser:parseAnd()
    local left = self:parseCompare()
    while self.current.kind == "Keyword" and self.current.value == "and" do
        self:advance()
        local right = self:parseCompare()
        left = Ast.AndExpression(left, right, self.settings.SimplifyConstants)
    end
    return left
end

function Parser:parseCompare()
    local left = self:parseConcat()
    while true do
        local op = self.current.value
        if op == "<" then self:advance(); left = Ast.LessThanExpression(left, self:parseConcat(), self.settings.SimplifyConstants)
        elseif op == ">" then self:advance(); left = Ast.GreaterThanExpression(left, self:parseConcat(), self.settings.SimplifyConstants)
        elseif op == "<=" then self:advance(); left = Ast.LessThanOrEqualsExpression(left, self:parseConcat(), self.settings.SimplifyConstants)
        elseif op == ">=" then self:advance(); left = Ast.GreaterThanOrEqualsExpression(left, self:parseConcat(), self.settings.SimplifyConstants)
        elseif op == "~=" then self:advance(); left = Ast.NotEqualsExpression(left, self:parseConcat(), self.settings.SimplifyConstants)
        elseif op == "==" then self:advance(); left = Ast.EqualsExpression(left, self:parseConcat(), self.settings.SimplifyConstants)
        else break end
    end
    return left
end

function Parser:parseConcat()
    local left = self:parseAddSub()
    while self.current.kind == "Symbol" and self.current.value == ".." do
        self:advance()
        local right = self:parseAddSub()
        left = Ast.StrCatExpression(left, right, self.settings.SimplifyConstants)
    end
    return left
end

function Parser:parseAddSub()
    local left = self:parseMulDivMod()
    while true do
        local op = self.current.value
        if op == "+" then self:advance(); left = Ast.AddExpression(left, self:parseMulDivMod(), self.settings.SimplifyConstants)
        elseif op == "-" then self:advance(); left = Ast.SubExpression(left, self:parseMulDivMod(), self.settings.SimplifyConstants)
        else break end
    end
    return left
end

function Parser:parseMulDivMod()
    local left = self:parseUnary()
    while true do
        local op = self.current.value
        if op == "*" then self:advance(); left = Ast.MulExpression(left, self:parseUnary(), self.settings.SimplifyConstants)
        elseif op == "/" then self:advance(); left = Ast.DivExpression(left, self:parseUnary(), self.settings.SimplifyConstants)
        elseif op == "%" then self:advance(); left = Ast.ModExpression(left, self:parseUnary(), self.settings.SimplifyConstants)
        else break end
    end
    return left
end

function Parser:parseUnary()
    if self.current.kind == "Symbol" and self.current.value == "-" then
        self:advance()
        local operand = self:parseUnary()
        return Ast.NegateExpression(operand, self.settings.SimplifyConstants)
    elseif self.current.kind == "Keyword" and self.current.value == "not" then
        self:advance()
        local operand = self:parseUnary()
        return Ast.NotExpression(operand, self.settings.SimplifyConstants)
    elseif self.current.kind == "Symbol" and self.current.value == "#" then
        self:advance()
        local operand = self:parseUnary()
        return Ast.LenExpression(operand, self.settings.SimplifyConstants)
    else
        return self:parsePower()
    end
end

function Parser:parsePower()
    local left = self:parsePrimary(false)
    if self.current.kind == "Symbol" and self.current.value == "^" then
        self:advance()
        local right = self:parseUnary()
        return Ast.PowExpression(left, right, self.settings.SimplifyConstants)
    end
    return left
end

function Parser:parsePrimary(allowCall)
    local tok = self.current
    if tok.kind == "Keyword" then
        if tok.value == "nil" then self:advance(); return Ast.NilExpression()
        elseif tok.value == "true" then self:advance(); return Ast.BooleanExpression(true)
        elseif tok.value == "false" then self:advance(); return Ast.BooleanExpression(false)
        elseif tok.value == "function" then return self:parseFunctionLiteral()
        else logger:error("Unexpected keyword " .. tok.value)
        end
    elseif tok.kind == "Number" then
        self:advance()
        return Ast.NumberExpression(tok.value)
    elseif tok.kind == "String" then
        self:advance()
        return Ast.StringExpression(tok.value)
    elseif tok.kind == "Symbol" then
        if tok.value == "..." then self:advance(); return Ast.VarargExpression()
        elseif tok.value == "(" then
            self:advance()
            local expr = self:parseExpression()
            self:expect("Symbol", ")")
            return self:handleCallSuffix(expr)
        elseif tok.value == "{" then
            return self:parseTableConstructor()
        end
    elseif tok.kind == "Ident" then
        return self:parseVariableOrCall()
    end
    logger:error("Unexpected token in expression: " .. tok.value)
end

function Parser:parseVariableOrCall()
    local scope, id = self.currentScope:resolve(self.current.value)
    local base = Ast.VariableExpression(scope, id)
    self:advance()
    return self:handleCallSuffix(base)
end

function Parser:handleCallSuffix(base)
    while true do
        if self.current.kind == "Symbol" and self.current.value == "[" then
            self:advance()
            local index = self:parseExpression()
            self:expect("Symbol", "]")
            base = Ast.IndexExpression(base, index)
        elseif self.current.kind == "Symbol" and self.current.value == "." then
            self:advance()
            local name = self:expect("Ident").value
            base = Ast.IndexExpression(base, Ast.StringExpression(name))
        elseif self.current.kind == "Symbol" and self.current.value == ":" then
            self:advance()
            local method = self:expect("Ident").value
            self:expect("Symbol", "(")
            local args = self:parseExpressionList()
            self:expect("Symbol", ")")
            base = Ast.PassSelfFunctionCallExpression(base, method, args)
        elseif self.current.kind == "Symbol" and self.current.value == "(" then
            self:advance()
            local args = self:parseExpressionList()
            self:expect("Symbol", ")")
            base = Ast.FunctionCallExpression(base, args)
        elseif self.current.kind == "String" or self.current.kind == "Symbol" and self.current.value == "{" then
            local arg
            if self.current.kind == "String" then
                arg = Ast.StringExpression(self.current.value)
                self:advance()
            else
                arg = self:parseTableConstructor()
            end
            base = Ast.FunctionCallExpression(base, { arg })
        else
            break
        end
    end
    return base
end

function Parser:parseExpressionList()
    local list = {}
    if self.current.kind == "Symbol" and self.current.value == ")" then
        return list
    end
    table.insert(list, self:parseExpression())
    while self.current.kind == "Symbol" and self.current.value == "," do
        self:advance()
        table.insert(list, self:parseExpression())
    end
    return list
end

function Parser:parseTableConstructor()
    self:expect("Symbol", "{")
    local entries = {}
    if self.current.kind ~= "Symbol" or self.current.value ~= "}" then
        while true do
            if self.current.kind == "Symbol" and self.current.value == "}" then break end
            local expr = self:parseExpression()
            if self.current.kind == "Symbol" and self.current.value == "=" then
                self:advance()
                local value = self:parseExpression()
                table.insert(entries, Ast.KeyedTableEntry(expr, value))
            else
                table.insert(entries, Ast.TableEntry(expr))
            end
            if self.current.kind == "Symbol" and (self.current.value == "," or self.current.value == ";") then
                self:advance()
                if self.current.kind == "Symbol" and self.current.value == "}" then break end
            else
                break
            end
        end
    end
    self:expect("Symbol", "}")
    return Ast.TableConstructorExpression(entries)
end

function Parser:parseFunctionLiteral()
    self:expect("Keyword", "function")
    self:expect("Symbol", "(")
    local args = self:parseFunctionArgs()
    self:expect("Symbol", ")")
    local body, _ = self:parseFunctionBody(args)
    self:expect("Keyword", "end")
    return Ast.FunctionLiteralExpression(args, body)
end

function Parser:parseFunctionArgs()
    local args = {}
    if self.current.kind == "Symbol" and self.current.value == ")" then
        return args
    end
    if self.current.kind == "Symbol" and self.current.value == "..." then
        table.insert(args, "...")
        self:advance()
        if self.current.kind == "Symbol" and self.current.value == ")" then return args end
        self:expect("Symbol", ",")
    end
    while true do
        local name = self:expect("Ident").value
        table.insert(args, name)
        if self.current.kind == "Symbol" and self.current.value == "," then
            self:advance()
            if self.current.kind == "Symbol" and self.current.value == "..." then
                table.insert(args, "...")
                self:advance()
                break
            end
        else
            break
        end
    end
    return args
end

function Parser:parseFunctionBody(args)
    local newScope = Scope:new(self.currentScope)
    for _, argName in ipairs(args or {}) do
        if argName ~= "..." then
            newScope:addVariable(argName)
        end
    end
    local oldScope = self.currentScope
    self.currentScope = newScope
    local body = self:parseBlock({ ["end"] = true })
    self.currentScope = oldScope
    return body, newScope
end

_MODULES["prometheus.parser"] = function() return Parser end
end

do
local Generator = {}
local Ast = require("prometheus.ast")
local AstKind = Ast.AstKind

local precedence = {
    [AstKind.OrExpression] = 12,
    [AstKind.AndExpression] = 11,
    [AstKind.LessThanExpression] = 10,
    [AstKind.GreaterThanExpression] = 10,
    [AstKind.LessThanOrEqualsExpression] = 10,
    [AstKind.GreaterThanOrEqualsExpression] = 10,
    [AstKind.NotEqualsExpression] = 10,
    [AstKind.EqualsExpression] = 10,
    [AstKind.StrCatExpression] = 9,
    [AstKind.AddExpression] = 8,
    [AstKind.SubExpression] = 8,
    [AstKind.MulExpression] = 7,
    [AstKind.DivExpression] = 7,
    [AstKind.ModExpression] = 7,
    [AstKind.NotExpression] = 5,
    [AstKind.LenExpression] = 5,
    [AstKind.NegateExpression] = 5,
    [AstKind.PowExpression] = 4,
    [AstKind.IndexExpression] = 1,
    [AstKind.FunctionCallExpression] = 2,
    [AstKind.PassSelfFunctionCallExpression] = 2,
}

function Generator:new(ast, settings)
    local g = { ast = ast, settings = settings or {}, indent = 0, output = {} }
    setmetatable(g, {__index = Generator})
    return g
end

function Generator:write(str)
    table.insert(self.output, str)
end

function Generator:newline()
    self:write("\n" .. string.rep("    ", self.indent))
end

function Generator:generate()
    self:generateNode(self.ast)
    return table.concat(self.output)
end

function Generator:generateNode(node)
    if not node then return end
    local kind = node.kind
    if kind == AstKind.TopNode then
        self:generateNode(node.body)
    elseif kind == AstKind.Block then
        for _, stmt in ipairs(node.statements) do
            self:generateNode(stmt)
            self:newline()
        end
    elseif kind == AstKind.NopStatement then
        self:write(";")
    elseif kind == AstKind.DoStatement then
        self:write("do")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        self:newline()
        self:write("end")
    elseif kind == AstKind.WhileStatement then
        self:write("while ")
        self:generateExpression(node.condition)
        self:write(" do")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        self:newline()
        self:write("end")
    elseif kind == AstKind.RepeatStatement then
        self:write("repeat")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        self:newline()
        self:write("until ")
        self:generateExpression(node.condition)
    elseif kind == AstKind.IfStatement then
        self:write("if ")
        self:generateExpression(node.condition)
        self:write(" then")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        for _, elseifClause in ipairs(node.elseifs or {}) do
            self:newline()
            self:write("elseif ")
            self:generateExpression(elseifClause.condition)
            self:write(" then")
            self.indent = self.indent + 1
            self:newline()
            self:generateNode(elseifClause.body)
            self.indent = self.indent - 1
        end
        if node.elsebody then
            self:newline()
            self:write("else")
            self.indent = self.indent + 1
            self:newline()
            self:generateNode(node.elsebody)
            self.indent = self.indent - 1
        end
        self:newline()
        self:write("end")
    elseif kind == AstKind.ForStatement then
        self:write("for ")
        self:write(node.scope:getVariableName(node.id))
        self:write(" = ")
        self:generateExpression(node.initialValue)
        self:write(", ")
        self:generateExpression(node.finalValue)
        if node.incrementBy and not (node.incrementBy.kind == AstKind.NumberExpression and node.incrementBy.value == 1) then
            self:write(", ")
            self:generateExpression(node.incrementBy)
        end
        self:write(" do")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        self:newline()
        self:write("end")
    elseif kind == AstKind.ForInStatement then
        self:write("for ")
        for i, id in ipairs(node.ids) do
            if i > 1 then self:write(", ") end
            self:write(node.scope:getVariableName(id))
        end
        self:write(" in ")
        for i, expr in ipairs(node.expressions) do
            if i > 1 then self:write(", ") end
            self:generateExpression(expr)
        end
        self:write(" do")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        self:newline()
        self:write("end")
    elseif kind == AstKind.FunctionDeclaration then
        self:write("function ")
        self:write(node.scope:getVariableName(node.id))
        for _, idx in ipairs(node.indices or {}) do
            self:write("." .. idx)
        end
        self:write("(")
        self:write(table.concat(node.args, ", "))
        self:write(")")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        self:newline()
        self:write("end")
    elseif kind == AstKind.LocalFunctionDeclaration then
        self:write("local function ")
        self:write(node.scope:getVariableName(node.id))
        self:write("(")
        self:write(table.concat(node.args, ", "))
        self:write(")")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        self:newline()
        self:write("end")
    elseif kind == AstKind.LocalVariableDeclaration then
        self:write("local ")
        for i, id in ipairs(node.ids) do
            if i > 1 then self:write(", ") end
            self:write(node.scope:getVariableName(id))
        end
        if #node.expressions > 0 then
            self:write(" = ")
            for i, expr in ipairs(node.expressions) do
                if i > 1 then self:write(", ") end
                self:generateExpression(expr)
            end
        end
    elseif kind == AstKind.AssignmentStatement then
        for i, lhs in ipairs(node.lhs) do
            if i > 1 then self:write(", ") end
            self:generateLHS(lhs)
        end
        self:write(" = ")
        for i, expr in ipairs(node.rhs) do
            if i > 1 then self:write(", ") end
            self:generateExpression(expr)
        end
    elseif kind == AstKind.CompoundAddStatement then
        self:generateLHS(node.lhs[1]); self:write(" += "); self:generateExpression(node.rhs[1])
    elseif kind == AstKind.CompoundSubStatement then
        self:generateLHS(node.lhs[1]); self:write(" -= "); self:generateExpression(node.rhs[1])
    elseif kind == AstKind.CompoundMulStatement then
        self:generateLHS(node.lhs[1]); self:write(" *= "); self:generateExpression(node.rhs[1])
    elseif kind == AstKind.CompoundDivStatement then
        self:generateLHS(node.lhs[1]); self:write(" /= "); self:generateExpression(node.rhs[1])
    elseif kind == AstKind.CompoundModStatement then
        self:generateLHS(node.lhs[1]); self:write(" %= "); self:generateExpression(node.rhs[1])
    elseif kind == AstKind.CompoundPowStatement then
        self:generateLHS(node.lhs[1]); self:write(" ^= "); self:generateExpression(node.rhs[1])
    elseif kind == AstKind.CompoundConcatStatement then
        self:generateLHS(node.lhs[1]); self:write(" ..= "); self:generateExpression(node.rhs[1])
    elseif kind == AstKind.ReturnStatement then
        self:write("return")
        if #node.args > 0 then
            self:write(" ")
            for i, expr in ipairs(node.args) do
                if i > 1 then self:write(", ") end
                self:generateExpression(expr)
            end
        end
    elseif kind == AstKind.BreakStatement then
        self:write("break")
    elseif kind == AstKind.ContinueStatement then
        self:write("continue")
    elseif kind == AstKind.FunctionCallStatement then
        self:generateExpression(node.base)
        self:write("(")
        self:generateExpressionList(node.args)
        self:write(")")
    elseif kind == AstKind.PassSelfFunctionCallStatement then
        self:generateExpression(node.base)
        self:write(":" .. node.passSelfFunctionName)
        self:write("(")
        self:generateExpressionList(node.args)
        self:write(")")
    elseif kind == AstKind.NilExpression then
        self:write("nil")
    elseif kind == AstKind.BooleanExpression then
        self:write(tostring(node.value))
    elseif kind == AstKind.NumberExpression then
        self:write(tostring(node.value))
    elseif kind == AstKind.StringExpression then
        self:write(string.format("%q", node.value))
    elseif kind == AstKind.VarargExpression then
        self:write("...")
    elseif kind == AstKind.FunctionLiteralExpression then
        self:write("function(")
        self:write(table.concat(node.args, ", "))
        self:write(")")
        self.indent = self.indent + 1
        self:newline()
        self:generateNode(node.body)
        self.indent = self.indent - 1
        self:newline()
        self:write("end")
    elseif kind == AstKind.TableConstructorExpression then
        self:write("{")
        for i, entry in ipairs(node.entries) do
            if i > 1 then self:write(", ") end
            if entry.kind == AstKind.KeyedTableEntry then
                self:write("[")
                self:generateExpression(entry.key)
                self:write("] = ")
                self:generateExpression(entry.value)
            else
                self:generateExpression(entry.value)
            end
        end
        self:write("}")
    else
        if precedence[kind] then
            self:generateExpression(node)
        else
            error("Unknown AST node kind: " .. kind)
        end
    end
end

function Generator:generateExpression(node, parentPrec)
    if not node then return end
    local prec = precedence[node.kind] or 0
    local needParen = parentPrec and prec > 0 and prec > parentPrec
    if needParen then self:write("(") end
    if node.kind == AstKind.OrExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" or "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.AndExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" and "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.LessThanExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" < "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.GreaterThanExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" > "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.LessThanOrEqualsExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" <= "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.GreaterThanOrEqualsExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" >= "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.NotEqualsExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" ~= "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.EqualsExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" == "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.StrCatExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" .. "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.AddExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" + "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.SubExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" - "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.MulExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" * "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.DivExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" / "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.ModExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" % "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.PowExpression then
        self:generateExpression(node.lhs, precedence[node.kind]); self:write(" ^ "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.NotExpression then
        self:write("not "); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.NegateExpression then
        self:write("-"); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.LenExpression then
        self:write("#"); self:generateExpression(node.rhs, precedence[node.kind])
    elseif node.kind == AstKind.IndexExpression then
        self:generateExpression(node.base, precedence[node.kind]); self:write("["); self:generateExpression(node.index); self:write("]")
    elseif node.kind == AstKind.FunctionCallExpression then
        self:generateExpression(node.base, precedence[node.kind]); self:write("("); self:generateExpressionList(node.args); self:write(")")
    elseif node.kind == AstKind.PassSelfFunctionCallExpression then
        self:generateExpression(node.base, precedence[node.kind]); self:write(":" .. node.passSelfFunctionName); self:write("("); self:generateExpressionList(node.args); self:write(")")
    elseif node.kind == AstKind.VariableExpression then
        self:write(node.scope:getVariableName(node.id))
    else
        self:generateNode(node)
    end
    if needParen then self:write(")") end
end

function Generator:generateLHS(node)
    if node.kind == AstKind.AssignmentVariable then
        self:write(node.scope:getVariableName(node.id))
    elseif node.kind == AstKind.AssignmentIndexing then
        self:generateExpression(node.base); self:write("["); self:generateExpression(node.index); self:write("]")
    end
end

function Generator:generateExpressionList(args)
    for i, expr in ipairs(args) do
        if i > 1 then self:write(", ") end
        self:generateExpression(expr)
    end
end

_MODULES["prometheus.generator"] = function() return Generator end
end

do
local passes = {}
local Ast = require("prometheus.ast")
local AstKind = Ast.AstKind
local util = require("prometheus.util")

function passes.RenameVariables(ast, settings)
    ast.globalScope:renameVariables(settings)
end

function passes.EncryptStrings(ast)
end

function passes.ShuffleStatements(ast)
    local function isSafeBlock(block)
        if block.kind ~= AstKind.Block then return false end
        for _, stmt in ipairs(block.statements) do
            if stmt.kind == AstKind.ReturnStatement or stmt.kind == AstKind.BreakStatement or stmt.kind == AstKind.ContinueStatement then
                return false
            end
        end
        return true
    end

    local function visit(node)
        if node.kind == AstKind.Block then
            if isSafeBlock(node) then
                util.shuffle(node.statements)
            end
            for _, stmt in ipairs(node.statements) do
                visit(stmt)
            end
        elseif node.kind == AstKind.IfStatement then
            visit(node.body)
            if node.elseifs then for _, eif in ipairs(node.elseifs) do visit(eif.body) end end
            if node.elsebody then visit(node.elsebody) end
        elseif node.kind == AstKind.WhileStatement then
            visit(node.body)
        elseif node.kind == AstKind.RepeatStatement then
            visit(node.body)
        elseif node.kind == AstKind.ForStatement or node.kind == AstKind.ForInStatement then
            visit(node.body)
        elseif node.kind == AstKind.FunctionDeclaration then
            visit(node.body)
        elseif node.kind == AstKind.LocalFunctionDeclaration then
            visit(node.body)
        elseif node.kind == AstKind.DoStatement then
            visit(node.body)
        end
    end

    visit(ast.body)
end

_MODULES["prometheus.passes"] = function() return passes end
end

do
local prometheus = {}

function prometheus.obfuscate(code, options)
    options = options or {}
    local config = require("config")
    local logger = require("logger")
    local Tokenizer = require("prometheus.tokenizer")
    local Parser = require("prometheus.parser")
    local Generator = require("prometheus.generator")
    local passes = require("prometheus.passes")
    local Enums = require("prometheus.enums")

    local tokenizer = Tokenizer:new({luaVersion = options.LuaVersion or "Lua51"})
    tokenizer:append(code)
    local parser = Parser:new(tokenizer, {SimplifyConstants = options.SimplifyConstants ~= false})
    local ast = parser:parse()

    if options.RenameVariables then
        local keywords = options.LuaVersion == "LuaU" and Enums.Conventions.LuaU.Keywords or Enums.Conventions.Lua51.Keywords
        passes.RenameVariables(ast, {
            Keywords = keywords,
            generateName = function(i, scope, orig)
                local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                if i <= #chars then
                    return chars:sub(i, i)
                else
                    return "_" .. tostring(i)
                end
            end,
            prefix = "",
        })
    end

    if options.EncryptStrings then
        passes.EncryptStrings(ast)
    end

    if options.ShuffleStatements then
        passes.ShuffleStatements(ast)
    end

    local generator = Generator:new(ast, {})
    return generator:generate()
end

_MODULES["prometheus"] = function() return prometheus end
end

local prometheus = require("prometheus")
