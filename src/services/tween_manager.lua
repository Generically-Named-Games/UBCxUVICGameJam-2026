-- MODULES
local Event = require("/classes/event")
--------------------------------------------------------------------------------
-- PRIVATE TWEEN CLASS (TO BE USED IN THIS FILE ONLY!)
--------------------------------------------------------------------------------
local Tween = {}
Tween.__index = Tween

function Tween.new(manager, target, duration, propertyName, endGoal, easingStyle)
	local instance = setmetatable({}, Tween)

	assert(type(target) == "table", "target parameter must be a table!")
	assert(type(duration) == "number", "duration parameter must be a number!")
	assert(type(propertyName) == "string", "propertyName parameter must be a string!")
	assert(type(endGoal) == "number", "endGoal parameter must be a number!")
	--PUBLIC
	instance.PlaybackState = "Begin"
	instance.Completed = Event.new()
	--PRIVATE
	instance._manager = manager
	instance._target = target
	instance._duration = 0
	instance._maxDuration = duration
	instance._propertyName = propertyName
	instance._start = target[propertyName]
	instance._endGoal = endGoal
	instance._easingStyle = easingStyle or "linear"

	return instance
end

-- Starts playback of a tween. Note that if playback has already started, calling Play() has no effect unless the tween has finished or is stopped (either by Tween:Cancel() or Tween:Pause()).
function Tween:Play()
	if self._duration >= self._maxDuration then
		self._duration = 0
	end
	self._manager:add(self)
end

-- Halts playback of the tween. Doesn't reset its progress variables, meaning that if you call Tween:Play(), the tween resumes playback from the moment it was paused.
function Tween:Pause()
	self.PlaybackState = "Paused"
end

-- Halts playback and resets the tween variables. If you then call Tween:Play(), the properties of the tween resume interpolating towards their destination, but take the full length of the animation to do so.
function Tween:Cancel()
	self.PlaybackState = "Cancelled"
end
--------------------------------------------------------------------------------
-- PUBLIC TWEENMANAGER CLASS
--------------------------------------------------------------------------------
local TweenManager = {}
TweenManager.__index = TweenManager

-- Creates a new TweenManager object. Should be treated as a singleton; however, it is not enforced.
function TweenManager.new()
	local instance = setmetatable({}, TweenManager)

	instance._active = {}
	instance._instancesUpdatedThisFrame = {}

	return instance
end

-- Creates a new Tween given the object whose properties are to be tweened, a TweenInfo, and a dictionary of goal property values.
function TweenManager:Create(target, duration, propertyName, endGoal, easingStyle)
	local newTween = Tween.new(self, target, duration, propertyName, endGoal, easingStyle)
	return newTween
end

function TweenManager.linear(ratio)
	return ratio
end
-- function TweenManager.quad(r) return r * r end
-- function TweenManager.cubic(r) return r * r * r end
-- function TweenManager.quart(r) return r * r * r *r end
-- function TweenManager.quint(r) return r * r * r * r * r end
-- function TweenManager.exponential(r) return 2 ^ (10 * (r -1)) end
--https://easings.net/ <-- IF NEED MORE

local function find(table, element)
	if #table <= 0 then
		return false
	end
	for i, v in pairs(table) do
		if v == element then
			return true
		end
	end
end

-- Callback function used by the TweenManager to update the state of all tweens each frame. Should be called from within love.draw()!
function TweenManager:update()
	for i, t in pairs(self._active) do
		if t.PlaybackState == "Cancelled" then
			table.remove(self._active, i)
		elseif t.PlaybackState == "Playing" or t.PlaybackState == "Queued" or t.PlaybackState == "Begin" then
			local difference = t._endGoal - t._start
			local easing = self[t._easingStyle](t._duration / t._maxDuration)

			if not find(self._instancesUpdatedThisFrame, t._target) then
				if t.PlaybackState ~= "Playing" then
					t._start = t._target[t._propertyName]
					t.PlaybackState = "Playing"
				end
				table.insert(self._instancesUpdatedThisFrame, t._target)

				if t._duration >= t._maxDuration then
					t._target[t._propertyName] = t._endGoal
					t.PlaybackState = "Completed"
					t.Completed:Invoke()
					table.remove(self._active, i)
				else
					t._target[t._propertyName] = math.floor(t._start + difference * easing)
					t._duration = t._duration + 1
				end
			else
				t.PlaybackState = "Queued"
			end
		end
	end
	self._instancesUpdatedThisFrame = {}
end

function TweenManager:add(tween)
	table.insert(self._active, tween)
end

return TweenManager
