discordia = require('discordia')
json = require('json')
timer = require('timer')
fs = require('fs')
client = discordia.Client()
discordia.extensions.string()



key = fs.readFileSync("key.txt","r") -- Put the key for the bot in a file in the same directory as main.lua

config = require('config')

require('util')



function handlePin(msg,person)
	if not msg.member then return end --For some reason there needs to be a check here too.
	local p = newEmbed()

	p:addAuthor()
	p:setAuthor(msg.member.name)
	p:setColor(msg.member:getColor())
	p:setDescription(msg.content)
	if msg.attachment and isImg(msg.attachment.filename) then
		p:addImage()
		p:setImage(msg.attachment.url)
	end

	p:addFooter()
	p:setFooter("Pinned by "..person.name..", sent")
	p:setTimestamp(msg.timestamp)
	return p
end

function hasCfg(srv)
	local id = srv.id

	if not config.servers[id] then return false end
	local cfg = config.servers[id]
	if not cfg.pinChannel then return false end
	if not cfg.adminRoles then return false end
	return true
end

function hasPerm(mem,srv)
	local ok = false
	for k,_ in next,config.servers[srv.id].adminRoles do
		if mem:hasRole(k) then
			ok = true
			break
		end
	end
	return ok
end

function isValidPin(react,srv)
	local msg = react.message
	if msg.channel == config.servers[srv.id].pinChannel then return end
	if react.emojiName ~= '📌' then return end
	if react.count > 1 then return end
	return true
end

function doReact(react,user)
	-- local person = g:getMember(user)
	-- local msg = react.message
	-- local allowed
	-- if not person then return end
	-- for k,_ in pairs(adminRoles) do
	-- 	if person:hasRole(k) then
	-- 		allowed = true
	-- 		break
	-- 	end
	-- end

	-- if msg.channel ~= pinChannel and react.emojiName == '📌' and react.count <= 1 and allowed then
	-- 	local cg = g:getChannel(pinChannel)
	-- 	local reply = handlePin(msg,person)
	-- 	if not reply then return end
	-- 	cg:send({embed = reply, content = msg.link})
	-- end
	local msg = react.message
	local srv = msg.guild
	local mem = msg.member
	local pm = srv:getMember(user)
	if not msg.member then return end
	print("passed membercheck")
	if not srv then return end
	print("passed guild check")
	if not hasCfg(srv) then return end --Let's make sure there's actually a config entry for this server
	print("passed config")
	if not isValidPin(react,srv) then return end --Is this a pin reaction?
	print("passed valid pin")
	if not hasPerm(pm,srv) then return end --Does the reaction adder have permission to create a pin?
	print("passed perm")
	local cfg = config.servers[srv.id]
	local reply = handlePin(msg,pm)
	if reply then
		local chan = srv:getChannel(cfg.pinChannel)
		chan:send({embed = reply, content = msg.link})
	end
end

client:on("reactionAdd",doReact)

client:run("Bot "..key)

client:on('ready',function() 
	print("loaded!!") 
	g = client:getGuild(guild)
end)