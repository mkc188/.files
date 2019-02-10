---
-- Vis Lua plugin API standard library
-- @module vis

---
-- @type Vis

--- Events.
--
-- User scripts can subscribe Lua functions to certain events. Multiple functions
-- can be associated with the same event. They will be called in the order they were
-- registered. The first function which returns a non `nil` value terminates event
-- propagation. The remaining event handler will not be called.
--
-- Keep in mind that the editor is blocked while the event handlers
-- are being executed, avoid long running tasks.
--
-- @section Events

--- Event names.
--- @table events
local events = {
	FILE_CLOSE = "Event::FILE_CLOSE", -- see @{file_close}
	FILE_OPEN = "Event::FILE_OPEN", -- see @{file_open}
	FILE_SAVE_POST = "Event::FILE_SAVE_POST", -- see @{file_save_post}
	FILE_SAVE_PRE = "Event::FILE_SAVE_PRE", -- see @{file_save_pre}
	INIT = "Event::INIT", -- see @{init}
	INPUT = "Event::INPUT", -- see @{input}
	QUIT = "Event::QUIT", -- see @{quit}
	START = "Event::START", -- see @{start}
	WIN_CLOSE = "Event::WIN_CLOSE", -- see @{win_close}
	WIN_HIGHLIGHT = "Event::WIN_HIGHLIGHT", -- see @{win_highlight}
	WIN_OPEN = "Event::WIN_OPEN", -- see @{win_open}
	WIN_STATUS = "Event::WIN_STATUS", -- see @{win_status}
}

events.init = function(...) events.emit(events.INIT, ...) end
events.win_open = function(...) events.emit(events.WIN_OPEN, ...) end

local handlers = {}

--- Subscribe to an event.
--
-- Register an event handler.
-- @tparam string event the event name
-- @tparam function handler the event handler
-- @tparam[opt] int index the index at which to insert the handler (1 is the highest priority)
-- @usage
-- vis.events.subscribe(vis.events.FILE_SAVE_PRE, function(file, path)
--	-- do something useful
--	return true
-- end)
events.subscribe = function(event, handler, index)
	if not event then error("Invalid event name") end
	if type(handler) ~= 'function' then error("Invalid event handler") end
	if not handlers[event] then handlers[event] = {} end
	events.unsubscribe(event, handler)
	table.insert(handlers[event], index or #handlers[event]+1, handler)
end

--- Unsubscribe from an event.
--
-- Remove a registered event handler.
-- @tparam string event the event name
-- @tparam function handler the event handler to unsubscribe
-- @treturn bool whether the handler was successfully removed
events.unsubscribe = function(event, handler)
	local h = handlers[event]
	if not h then return end
	for i = 1, #h do
		if h[i] == handler then
			table.remove(h, i)
			return true
		end
	end
	return false
end

--- Generate event.
--
-- Invokes all event handlers in the order they were registered.
-- Passes all arguments to the handler. The first handler which returns a non `nil`
-- value terminates the event propagation. The other handlers will not be called.
--
-- @tparam string event the event name
-- @tparam ... ... the remaining paramters are passed on to the handler
events.emit = function(event, ...)
	local h = handlers[event]
	if not h then return end
	for i = 1, #h do
		local ret = h[i](...)
		if type(ret) ~= 'nil' then return ret end
	end
end

vis.events = events

-- standard vis event handlers

local modes = {
	[vis.modes.NORMAL] = '',
	[vis.modes.OPERATOR_PENDING] = '',
	[vis.modes.VISUAL] = 'VISUAL',
	[vis.modes.VISUAL_LINE] = 'VISUAL-LINE',
	[vis.modes.INSERT] = 'INSERT',
	[vis.modes.REPLACE] = 'REPLACE',
}

-- default plugins

require('plugins/complete-word')
require('plugins/complete-filename')

-- v0.5
-- visrc.lua
os.capture = function(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	s = s:gsub('%s+$', '')
	return s
end

open = function()
	vis.pwd = os.capture('pwd') .. '/'
	fname = vis.win.file.name or '.'
	local dir
	if fname:sub(1, 1) == '/' then
		dir = fname
	else
		dir = vis.pwd .. '/' .. fname
	end
	vis.cwd = os.capture('dirname ' .. dir) .. '/'

	local path = vis.cwd
	if path ~= '' then
		vis:feedkeys(':e ' .. path .. '<Enter>')
	else
		vis:feedkeys('<C-l>')
	end
end

fzf = function()
	local path = os.capture('fzf')
	if path ~= '' then
		vis:feedkeys(':e ' .. path .. '<Enter>')
	else
		vis:feedkeys('<C-l>')
	end
end

ag = function()
	local path = os.capture('ag --nobreak --no-numbers --noheading . | fzf --no-extended --exact --no-sort')
	if path ~= '' then
		vis:feedkeys(':e ' .. string.match(path, "(.-):") .. '<Enter>')
	else
		vis:feedkeys('<C-l>')
	end
end

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	vis:command('set tabwidth 2')
	vis:command('set expandtab')
	vis:command('set autoindent')

	vis:command('map! normal Q @q')
	vis:command('map! normal j gj')
	vis:command('map! visual j gj')
	vis:command('map! normal k gk')
	vis:command('map! visual k gk')

	vis:command('map! normal <Space> :')
	vis:command('map! visual <Space> :')
	vis:command('map! visual-line <Space> :')
	vis:command('map! operator-pending <Space> :')

	vis:command('map! normal x \'v"_d\'')
	vis:command('map! visual x \'"_d\'')
	vis:command('map! visual-line x \'"_d\'')

	vis:command('map! visual p \'"_dP\'')
	vis:command('map! visual-line p \'"_dP\'')

	vis:command('map! visual Y \'"+y\'')
	vis:command('map! visual-line Y \'"+y\'')

	vis:map(vis.modes.NORMAL, '-', open)
	vis:map(vis.modes.NORMAL, '<F3>', fzf)
	vis:map(vis.modes.NORMAL, '<F4>', ag)
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Your per window configuration options
end)
