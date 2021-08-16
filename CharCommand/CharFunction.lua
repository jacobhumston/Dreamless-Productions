local chatservice = require(game:GetService("ServerScriptService"):WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))

script.Fire.Event:Connect(function(player, name, channel, arguments, normalarguments, matchsize)
	local chatspeaker = chatservice:GetSpeaker(name)
	
	local humanoiddescription = nil

	local success, err = pcall(function()
		humanoiddescription = game:GetService("Players"):GetHumanoidDescriptionFromUserId(game:GetService("Players"):GetUserIdFromNameAsync(arguments[2]))
	end)

	if humanoiddescription ~= nil then
		if player.Character.Humanoid:FindFirstChild("HumanoidDescription") then
			if matchsize == true then
				local pasthumanoiddescription = player.Character.Humanoid.HumanoidDescription
				humanoiddescription.BodyTypeScale = pasthumanoiddescription.BodyTypeScale
				humanoiddescription.DepthScale = pasthumanoiddescription.DepthScale
				humanoiddescription.HeadScale = pasthumanoiddescription.HeadScale
				humanoiddescription.HeightScale = pasthumanoiddescription.HeightScale
				humanoiddescription.ProportionScale = pasthumanoiddescription.ProportionScale
				humanoiddescription.WidthScale = pasthumanoiddescription.WidthScale
			end
		end
	end
	
	if success then
		player.Character.Humanoid:ApplyDescription(humanoiddescription)
		chatspeaker:SendSystemMessage("Successfully made your character look like "..normalarguments[2].."!", channel)
	else
		chatspeaker:SendSystemMessage("An error occurred, did you provide the correct username? If so, that user might be terminated.", channel)
	end
end)
