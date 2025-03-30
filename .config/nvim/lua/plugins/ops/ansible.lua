local M = { 'mfussenegger/nvim-ansible' }

M.ft = {}

-- stylua: ignore
M.keys = {
  { '<leader>ta', function() require('ansible').run() end, desc = 'Ansible Run Playbook/Role', silent = true },
}

return M
