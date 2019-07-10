--[[
	CONFIG FILE FOR PIN BOT, FORMATTED AS SHOWN BELOW
]]

config = {}


config.servers = {
	
	["239599630805893121"] = { --server ID

		adminRoles = {
		
			["504807141580865551"] = true, --role ID1
			["504808768488341505"] = true --role ID2

		},

		pinChannel = "504807285923774468" --channel ID
	},

	["505200471909335045"] = {

		adminRoles = {
			["505201887281414155"] = true
		},

		pinChannel = "505202070840934404"
	}
}

return config