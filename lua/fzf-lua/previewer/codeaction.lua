  local ff = vim.bo[bufnr].fileformat
        -- delta needs file mode
        table.insert(diff, "new file mode 100644")
        -- diff-so-fancy needs index
        table.insert(diff, "index 0000000..fffffff")
local function preview_action_tuple(self, idx, callback)
  local tuple = self.opts._items[idx]
  -- First check our resolved action cache, if "codeAction/resolve" failed, ignore
  -- the error (we already alerted the user about it in `handle_resolved_response`)
  -- and display the default "unsupported" message from the original action
  if self._resolved_actions[idx] then
    local resolved = self._resolved_actions[idx]
    return diff_tuple(nil, not resolved.err and resolved.tuple or tuple, self.diff_opts)
  end
  -- Not found in cache, check if the client supports code action resolving
  local client_id = tuple[1]
  local client = assert(vim.lsp.get_client_by_id(client_id))
  local supports_resolve = utils.__HAS_NVIM_010
      -- runtime/lua/lsp/buf.lua:on_user_choice
      and (function()
        ---@var choice {action: lsp.Command|lsp.CodeAction, ctx: lsp.HandlerContext}
        local ms = require("vim.lsp.protocol").Methods
        local choice = self.opts._items[idx]
        local bufnr = assert(choice.ctx.bufnr, "Must have buffer number")
        local reg = client.dynamic_capabilities:get(ms.textDocument_codeAction, { bufnr = bufnr })
        return vim.tbl_get(reg or {}, "registerOptions", "resolveProvider")
            or client.supports_method(ms.codeAction_resolve)
      end)()
      -- prior to nvim 0.10 we could check `client.server_capabilities`
      or vim.tbl_get(client.server_capabilities, "codeActionProvider", "resolveProvider")
  if not action.edit and client and supports_resolve then
    -- Action is not a worksapce edit, attempt to resolve the code action
    -- in case it resolves to a workspace edit
    local function handle_resolved_response(err, resolved_action)
        -- alert the user "codeAction/resolve" request  failed
        utils.warn(diff_tuple(err, nil, self.diff_opts)[1])
      local resolved = {
        err = err,
        -- Due to a bug in `typescript-tools.nvim` only the first call to `codeAction/resolve`
        -- returns a valid action (non-nil), return nil tuple if the action is nil (#949)
        tuple = resolved_action and { client_id, resolved_action } or nil
      }
      self._resolved_actions[idx] = resolved
      -- HACK: due to upstream bug with jdtls calling resolve messes
      -- errs the workspace edit with "-32603: Internal error." (#1007)
      if not err and client.name == "jdtls" then
        if utils.__HAS_NVIM_010 then
          self.opts._items[idx].action = resolved_action
        else
          self.opts._items[idx][2] = resolved_action
        end
      end
      return resolved.tuple
        local resolved_tuple = handle_resolved_response(err, resolved_action)
        callback(nil, not err and resolved_tuple or tuple)
      local resolved_tuple = handle_resolved_response(err, resolved_action)
      return diff_tuple(nil, not err and resolved_tuple or tuple, self.diff_opts)
    return diff_tuple(nil, tuple, self.diff_opts)
M.builtin.preview_action_tuple = preview_action_tuple
  self._resolved_actions = {}
  for i, _ in ipairs(self.opts._items) do
    self._resolved_actions[i] = false
  end
  local lines = self:preview_action_tuple(idx,
  vim.bo[self.tmpbuf].filetype = "git"
M.native.preview_action_tuple = preview_action_tuple
  self._resolved_actions = {}
  for i, _ in ipairs(self.opts._items) do
    self._resolved_actions[i] = false
  end
    local lines = self:preview_action_tuple(idx)
    act = act .. " | " .. utils._if_win_normalize_vars(self.pager)