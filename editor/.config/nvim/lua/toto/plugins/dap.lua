return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup({
            controls = {
                element = "repl",
                enabled = false,
            },
            mappings = {
                edit = "e",
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "x",
                repl = "r",
                toggle = "t",
            },
        })

        require("nvim-dap-virtual-text").setup({
            virt_text_pos = "eol",
            commented = true,
            display_callback = function(variable, _, _, _, _)
                local text = variable.value
                if text:len() > 80 then
                    text = text:sub(1, 50) .. "..."
                end
                return text
            end,
        })

        require("dap-go").setup()

        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = "codelldb",
                args = { "--port", "${port}" },
            },
        }

        dap.configurations.zig = {
            {
                name = 'Launch',
                type = 'codelldb',
                request = 'launch',
                program = '${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}',
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
            },
        }

        vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)

        vim.keymap.set("n", "<space>di", function()
            dapui.eval(nil, { enter = true })
        end)

        vim.keymap.set("n", "<space>dc", dap.continue);
        vim.keymap.set("n", "<space>dr", dap.restart);
        vim.keymap.set("n", "<space>dx", dap.terminate);
        vim.keymap.set("n", "<space>dsi", dap.step_into);
        vim.keymap.set("n", "<space>dso", dap.step_over);
        vim.keymap.set("n", "<space>dse", dap.step_out);
        vim.keymap.set("n", "<space>dsu", dap.step_back);

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end
}
