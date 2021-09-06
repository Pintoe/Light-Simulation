local startBlock = workspace:WaitForChild("LightFolder"):WaitForChild("StartPart")

local templatePart = Instance.new("Part")
templatePart.Anchored = true
templatePart.Name = "newPartAngled"
templatePart.Color = Color3.new(1, 23, 0)

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {startBlock}
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

local startPosition = startBlock.Position

local tau = math.pi*2
local radius = 70 -- increare to make circle of light bigger
local slices = 3000-- increase to make light more precise (reccommended formula: radius*12)
local increment = tau/slices

local blackList = table.create(slices+1)

templatePart.Size = Vector3.new(increment, increment, increment)*radius

local function connectPoints(part, endPosition)
	part.Size = Vector3.new(
		part.Size.X, part.Size.Y, 
		(startPosition - endPosition).Magnitude
	)
	
	part.CFrame = CFrame.new(
		startPosition:Lerp(endPosition, 0.5), 
		endPosition
	)
	return part
end

local function newPart(endPosition)
	return connectPoints(templatePart:Clone(), Vector3.new(endPosition.X, startPosition.Y, endPosition.Z))
end

for angle = 0, tau, increment do
	local cos = math.cos(angle)
	local sin = math.sin(angle)
	
	local endPosition = startPosition+(Vector3.new(cos, 0, sin)*radius)

	local rayResult = workspace:Raycast(startPosition, endPosition, raycastParams)
	
	local p = newPart(rayResult and Vector3.new(rayResult.Position.X, 0, rayResult.Position.Z) or endPosition)
	p.Parent = workspace
	
	table.insert(blackList, p)
	raycastParams.FilterDescendantsInstances = blackList
	
	task.wait()
end
