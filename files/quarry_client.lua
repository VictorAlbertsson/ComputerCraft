-- function split(str, sep)
--     if sep == nil then
-- 	sep = "%s"
--     end
--     local t = {}
--     for str in string.gmatch(str, "([^" .. sep .. "]+)") do
-- 	table.insert(t, str)
--     end
--     return t
-- end
-- 
-- function parseMessage(data)
--     local coords = {}
--     params = split(data, " ")
--     coords[1] = vector.new(params[1], params[2], params[3])
--     coords[2] = vector.new(params[4], params[5], params[6])
--     coords[3] = vector.new(params[7], params[8], params[9])
--     return coords
-- end

-- Currently does not return the computed values
function call(f, count)
    for i = 1, count do
	f()
    end
end

function invertHeading(heading)
    return (heading + 1) % 4 + 1
end

function turtle:forceForward()
    while self.detect() do
	self.dig()
    end
    self.forward()
end

function turtle:forceUp()
    while self.detectUp() do
	self.digUp()
    end
    self.up()
end

function turtle:forceDown()
    while self.detectDown() do
	self.digDown()
    end
    self.down()
end

function turtle:heading()
    -- Currently only a helper function
    v1 = vector.new(gps.locate(2, false))
    self:forceForward()
    v2 = vector.new(gps.locate(2, false))
    delta = v2 - v1
    return delta.x + math.abs(delta.x) * 2 + delta.z + math.abs(delta.z) * 3
end

function turtle:turnTo(current_heading, target_heading)
    if current_heading > target_heading then
	for t = 1, math.abs(target_heading - current_heading) do
	    self.turnLeft()
	end
    elseif current_heading < target_heading then
	for t = 1, math.abs(target_heading - current_heading) do
	    self.turnRight()
	end
    end
    -- The turtle should now be facing the 'target_heading'
    return target_heading
end

function turtle:advanceColumn(layer, heading)
    -- TODO Move boilerplate 'turn' code into a 'uTurn' function
    if heading == 2 or heading == 3 then
	-- 2 = North, 3 = East
	if layer % 2 == 1 then
	    -- %2 means every other layer
	    -- Do a rightward U-turn
	    self.turnRight()
	    self:forceForward()
	    self.turnRight()
	else
	    -- Do a leftward U-turn
	    self.turnLeft()
	    self:forceForward()
	    self.turnLeft()
	end
    elseif heading == 1 or heading == 4 then
	-- 1 = South, 4 = West
	if layer % 2 == 1 then
	    -- %2 means every other layer
	    -- Do a leftward U-turn
	    self.turnLeft()
	    self:forceForward()
	    self.turnLeft()
	else
	    -- Do a rightward U-turn
	    self.turnRight()
	    self:forceForward()
	    self.turnRight()		
	end
    else
	print("ERROR: Heading not in range 1 <= h <= 4, this should never happen!")
    end
    return invertHeading(heading)
end

function turtle:advanceLayer(heading)
    self:forceDown()
    return self:turnTo(heading, invertHeading(heading))
end

function turtle:digCube(size, heading)
    for layer = 1, size do
	for column = 1, size do
	    for row = 1, size - 1 do
		if row == size - 1 then
		    heading = self:advanceColumn(layer, heading)
		else
		    self:forceForward()
		end
	    end
	    if column == size then
		heading = self:advanceLayer(heading)
	    end
	end
	if layer == size then
	    -- TODO Code to execute when done
	    print("Done!")
	end
    end
end

-- function startClient()
--     -- local slotCount  = 16
--     local clientPort = 0
--     local serverPort = 100
--     local modem = peripheral.wrap("left")
--     modem.open(CLIENT_PORT)
--     modem.transmit(serverPort, clientPort, "CLIENT_DEPLOYED")
--     event, side, senderChannel, replyChannel, message, distance = os.pullEvent("modem_message")
--     local data = parseMessage(message)
--     local finalHeading = turtle.digCube(quarry.size, heading)
--     modem.transmit(serverPort, clientPort, "CLIENT_DONE")
-- end
