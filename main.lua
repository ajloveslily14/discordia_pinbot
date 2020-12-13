discordia = require("discordia")
fs = require("fs")
client = discordia.Client()



key = fs.readFileSync("key.txt","r") -- Put the key for the bot in a file in the same directory as main.lua

config = require("config") -- put a file named config.lua in the same directory as this file, copy from example config.


function isImg(str)
	if str:find(".jpg") then return true end
	if str:find(".jpeg") then return true end
	if str:find(".png") then return true end
	if str:find(".gif") then return true end
	return false
end

function handlePin(msg,person)
	if not msg.member then return end --For some reason there needs to be a check here too.
	local p = {}

	p.author = {}
	p.author.name = msg.member.name
	p.color = msg.member:getColor().value or math.random(0xFFFFFF)
	p.description = msg.content
	if msg.attachment and isImg(msg.attachment.filename) then
		p.image = {url=msg.attachment.url}
	end

	p.footer = {text="Pinned by "..person.name..", sent"}
	p.timestamp = msg.timestamp
	p.fields = {}
	p.fields[1] = {}
	p.fields[1].name = "Original"
	p.fields[1].value = "[Jump!]("..msg.link..")"
	return p
end

function hasCfg(srv)
	local id = srv.id

	if not config.servers[id] then return false end
	local cfg = config.servers[id]
	if not cfg.pinChannel then return false end
	return true
end

function hasPerm(mem,chan)
	return mem:hasPermission(chan,"manageMessages")
end

function isValidPin(react,srv)
	local msg = react.message
	if msg.channel == config.servers[srv.id].pinChannel then return end
	if react.emojiName ~= "\240\159\147\140" then return end
	if react.count > 1 then return end
	return true
end

function doReact(react,user)
	local msg = react.message
	local srv = msg.guild
	if not srv then return end
	local pm = srv:getMember(user)
	if not pm then return end -- make sure there's a member attached to the reaction to check perms
	if not hasCfg(srv) then return end --Let's make sure there's actually a config entry for this server
	if not isValidPin(react,srv) then return end --Is this a pin reaction?
	if not hasPerm(pm,react.channel) then return react:delete(user) end --Does the reaction adder have permission to create a pin? If not delete the reaction.
	local cfg = config.servers[srv.id]
	local reply = handlePin(msg,pm)
	if reply then
		local chan = srv:getChannel(cfg.pinChannel)
		chan:send({embed = reply})
	end
end

client:on("reactionAdd",doReact)

client:on("reactionAddUncached",function(chan,mid,hash,userid)
	if hash ~= "\240\159\147\140" then return end
	local ref
	local msg = chan:getMessage(mid)
	for react in msg.reactions:iter() do
		if react.emojiName == hash then
			ref = react
			break
		end
	end
	if ref and ref.count <= 1 then
		doReact(ref,userid)
	end
end)

client:run("Bot "..key)

client:on("ready",function() 
	print("Logged in as "..client.user.username) 
end)