-- v0.5
require('vis')

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
  vis:command('set theme dark-16')

  vis:command('map! normal H ^')
  vis:command('map! visual H ^')
  vis:command('map! visual-line H ^')
  vis:command('map! operator-pending H ^')
  vis:command('map! normal L g_')
  vis:command('map! visual L g_')
  vis:command('map! visual-line L g_')
  vis:command('map! operator-pending L g_')

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
  vis:map(vis.modes.NORMAL, '\\', fzf)
  vis:map(vis.modes.NORMAL, '<F4>', ag)
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  -- Your per window configuration options
end)
