embed = {
	addAuthor = function(self)
		local a = {}
		self.author = a
	end,

	setAuthor = function(self,name)
		self.author.name = name
	end,
	
	setAuthorImage = function(self,image)
		self.author.icon_url = image
	end,

	setAuthorUrl = function(self,link)
		self.author.url = link
	end,

	setColor = function(self,color)
		self.color = color.value
	end,

	addImage = function(self)
		local i = {}
		self.image = {}
	end,

	setImage = function(self,str)
		self.image.url = str
	end,

	addFooter = function(self)
		local f = {}
		self.footer = f
	end,

	setFooter = function(self,str)
		self.footer.text = str
	end,

	setFooterIcon = function(self,url)
		self.footer.icon_url = url
	end,

	setTitle = function(self,text)
		self.title = text
	end,

	setTimestamp = function(self,time)
		self.timestamp = time
	end,

	setDescription = function(self,desc)
		self.description = desc
	end,

	setContent = function(self,text)
		self.content = text
	end

}
embed.__index = embed

function newEmbed()
	return setmetatable( {}, embed )
end

function isImg(str)
	if str:find(".jpg") then return true end
	if str:find(".jpeg") then return true end
	if str:find(".png") then return true end
	if str:find(".gif") then return true end
	return false
end