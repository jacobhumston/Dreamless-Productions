-- SETTINGS --

local prefix = "/"
local matchsize = false
local hidemessage = true
local gamepassid = nil -- leave nil if you dont want the command to require a gamepass
local needswhitelist = false -- set to true if you want only players in whitelist to use the command
local whitelist = {} 
-- list of user ids of who you would like to use this command, requires needswhitelist to be true
-- owner of the game/group is added by default, so you dont need to add them yourself
-- Examples: local whitelist = {1,2,3}

-- END OF SETTINGS --

local gamepassusers = {} 

local chatservice = require(game:GetService("ServerScriptService"):WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))

game:GetService("Chat"):RegisterChatCallback(Enum.ChatCallbackType.OnServerReceivingMessage, function(message)
	local chatspeaker = chatservice:GetSpeaker(message.FromSpeaker)
	local arguments = message.Message:lower():split(" ")
	local player = chatspeaker:GetPlayer()
	local normalarguments = message.Message:split(" ")

	if player == nil then
		return message
	end

	if arguments[1] == prefix.."char" then
		if hidemessage == true then
			message.ShouldDeliver = false
		end

		if gamepassid ~= nil then
			if table.find(gamepassusers, player.UserId) == nil then
				chatspeaker:SendSystemMessage("You need to own the gamepass to use this command.", message.OriginalChannel)
				return message
			end
		end	
		
		if needswhitelist == true then
			if table.find(whitelist, player.UserId) == nil then
				chatspeaker:SendSystemMessage("You are not whitelisted to use this command.", message.OriginalChannel)
				return message
			end
		end
		
		if arguments[2] == nil then
			chatspeaker:SendSystemMessage("Please provide a username.", message.OriginalChannel)
		elseif player.Character == nil then
			chatspeaker:SendSystemMessage("Character has not loaded.", message.OriginalChannel)
		else
			script.CharFunction.Fire:Fire(player, chatspeaker.Name, message.OriginalChannel, arguments, normalarguments, matchsize)
		end
	end

	return message
end)

if game.CreatorType == Enum.CreatorType.User then
	table.insert(whitelist, game.CreatorId)	
end

game:GetService("Players").PlayerAdded:Connect(function(player)
	if game.CreatorType == Enum.CreatorType.Group then
		if player:GetRankInGroup(game.CreatorId) == 255 then
			table.insert(whitelist, player.UserId)
		end
	end
	if gamepassid ~= nil then
		local success, err = pcall(function()
			if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, gamepassid) then
				table.insert(gamepassusers, player.UserId)
			end
		end)
	end
end)
