game.Workspace.DescendantAdded:connect(function(des)
	wait(1)
	if des == nil then return end
	if des.Name == "Health" then
		if des == nil then return end
		des:remove()
	end
end)
