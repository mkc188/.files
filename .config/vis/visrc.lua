-- load standard vis module, providing parts of the Lua API
require('vis')

os.capture = function(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  s = s:gsub('%s+$', '')
  return s
end

vifm = function()
  vis.pwd = os.capture('pwd') .. '/'
  fname = vis.win.file.name or '.'
  local dir
  if fname:sub(1, 1) == '/' then
    dir = fname
  else
    dir = vis.pwd .. '/' .. fname
  end
  vis.cwd = os.capture('dirname ' .. dir) .. '/'

  local path = os.capture('vifm ' .. vis.cwd .. ' --choose-files -')
  if path ~= '' then
    vis:feedkeys(':e ' .. path .. '<Enter>')
  else
    vis:feedkeys('<editor-redraw>')
  end
end

fzf = function()
  local path = os.capture('fzf')
  if path ~= '' then
    vis:feedkeys(':e ' .. path .. '<Enter>')
  else
    vis:feedkeys('<editor-redraw>')
  end
end

vis.events.win_open = function(win)
  -- enable syntax highlighting for known file types
  vis.filetype_detect(win)

  -- Your local configuration options e.g.
  -- vis:command('set number')
  -- vis:command('map! normal j gj')
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
  vis:command('map! normal k gk')

  vis:command('map! normal <Space> <prompt-show>')
  vis:command('map! visual <Space> <prompt-show>')
  vis:command('map! visual-line <Space> <prompt-show>')
  vis:command('map! operator-pending <Space> <prompt-show>')

  vis:command('map! normal x v<register>_d')
  vis:command('map! visual x <register>_d')
  vis:command('map! visual-line x <register>_d')

  vis:command('map! visual s <register>_d<register>0P')
  vis:command('map! visual-line s <register>_d<register>0P')

  vis:command('map! visual Y <register>+y')
  vis:command('map! visual-line Y <register>+y')

  vis:command('map! insert <C-a> <cursor-line-start>')
  vis:command('map! insert <C-b> <Left>')
  vis:command('map! insert <C-d> <Backspace>')
  vis:command('map! insert <C-e> <cursor-line-end>')
  vis:command('map! insert <C-f> <Right>')

  vis:map(vis.MODE_NORMAL, '-', vifm)
  vis:map(vis.MODE_NORMAL, '\\', fzf)
end
