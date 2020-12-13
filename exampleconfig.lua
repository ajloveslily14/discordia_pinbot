--[[
	CONFIG FILE FOR PIN BOT, FORMATTED AS SHOWN BELOW
]]

config = {}


config.servers = { -- Note that the bot just checks if the person reacting with the pin has permission to pin messages.
	
	["239599630805893121"] = { --server ID
		pinChannel = "504807285923774468" --channel ID
	},

	["505200471909335045"] = {
		pinChannel = "505202070840934404"
	}
}

return config