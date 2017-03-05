-- 5b3c070e979b4a61659eae33668d702ef97291a2
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

ag = function()
  local path = os.capture('ag --nobreak --no-numbers --noheading . | fzf --no-extended --exact --no-sort')
  if path ~= '' then
    vis:feedkeys(':e ' .. string.match(path, "(.-):") .. '<Enter>')
  else
    vis:feedkeys('<editor-redraw>')
  end
end

vis.events.start = function()
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

  vis:command('map! normal <Space> <prompt-show>')
  vis:command('map! visual <Space> <prompt-show>')
  vis:command('map! visual-line <Space> <prompt-show>')
  vis:command('map! operator-pending <Space> <prompt-show>')

  vis:command('map! normal x v<register>_d')
  vis:command('map! visual x <register>_d')
  vis:command('map! visual-line x <register>_d')

  vis:command('map! visual p <register>_dP')
  vis:command('map! visual-line p <register>_dP')

  vis:command('map! visual Y <register>+y')
  vis:command('map! visual-line Y <register>+y')

  vis:command('map! insert <C-a> <cursor-line-start>')
  vis:command('map! insert <C-b> <Left>')
  vis:command('map! insert <C-d> <Delete>')
  vis:command('map! insert <C-e> <cursor-line-end>')
  vis:command('map! insert <C-f> <Right>')

  vis:command('map! insert <Backspace> <vis-mode-normal><register>_X<vis-mode-insert>')

  vis:command('map! visual <C-d> <window-halfpage-down>')
  vis:command('map! visual-line <C-d> <window-halfpage-down>')
  vis:command('map! visual <C-u> <window-halfpage-up>')
  vis:command('map! visual-line <C-u> <window-halfpage-up>')

  vis:map(vis.MODE_NORMAL, '-', vifm)
  vis:map(vis.MODE_NORMAL, '\\', fzf)
  vis:map(vis.MODE_NORMAL, '<F4>', ag)
end

vis.events.win_open = function(win)
  vis.filetype_detect(win)
end
