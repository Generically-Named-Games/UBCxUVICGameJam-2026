---@class Event
---@field private _callback function
local Event = {}
Event.__index = Event

---Creates a new event. Can have its callback set with :Connect() that can be invoked with :Invoke()
function Event.new()
	local instance = setmetatable({}, Event)

	instance._callback = nil

	return instance
end

---Connects the given function to the event. When the event is invoked, the function given as a callback will be called.
---@param callback function
function Event:Connect(callback)
	assert(type(callback) == "function", "Event must have a function for its callback parameter!")
	self._callback = callback
end

---Connects any callback given by Event:Connect() to the event.
function Event:Disconnect()
	self._callback = nil
end

---Should never be called from any non-class module! Invokes an event, causing any callbacks connected by Event:Connect() to be called.
function Event:Invoke()
	if self._callback == nil then
		return
	end
	self._callback()
end

return Event
