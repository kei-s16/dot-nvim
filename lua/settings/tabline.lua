-- ブランチ情報を取得できればする
local function get_current_branch_name()
  local branch_name = vim.fn.trim(vim.fn.system('git branch --show-current 2>/dev/null')) -- pwdで実行される
  return branch_name
end

-- tablineを描画する関数
-- グローバルに登録する必要あり
function _G.render_tabline()
  local tabline = ''
  local tab_length = vim.fn.tabpagenr('$')

  for i = 1, tab_length do
    -- タブの名前を取得する
    local name = vim.fn.bufname(vim.fn.tabpagebuflist(i)[1])
    if name == '' then
      name = '[No Name]'
    end

    -- タブの情報を追加する
    tabline = tabline .. (i == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#') -- カレントタブならハイライト
    tabline = tabline .. ' ' .. i .. ': ' -- タブ番号表示
    tabline = tabline .. (i == vim.fn.tabpagenr() and name or ' ')  -- カレントタブならバッファ名を出す
    tabline = tabline .. (i == vim.fn.tabpagenr() and '%m ' or ' ') -- 差分が発生していれば表示する
  end

  tabline = tabline .. '%#TabLineFill#%T%#TabLine#' -- 余白埋め

  tabline = tabline .. '%=' -- ここから右側
  tabline = tabline .. get_current_branch_name() -- ブランチ名

  return tabline
end

-- tablineを設定する
vim.o.tabline = '%!v:lua.render_tabline()'
