const std = @import("std");

const max_fzf_output_len = 100;
const lookup_dirs = [_][]const u8{
    "dev",
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var env_map = try std.process.getEnvMap(allocator);
    defer env_map.deinit();

    const home_path = env_map.get("HOME") orelse return error.HomeVarNotFound;
    const inside_tmux = if (env_map.get("TMUX")) |_| true else false;

    const fzf_exe = if (inside_tmux) "fzf-tmux" else "fzf";
    var fzf_proc = std.process.Child.init(&.{fzf_exe}, allocator);
    fzf_proc.stdin_behavior = .Pipe;
    fzf_proc.stdout_behavior = .Pipe;
    fzf_proc.stderr_behavior = .Pipe;

    try fzf_proc.spawn();

    {
        const fzf_stdin = fzf_proc.stdin.?.writer();

        var home_dir = try std.fs.openDirAbsolute(home_path, .{});
        defer home_dir.close();

        for (lookup_dirs) |dir_name| {
            var dir = try home_dir.openDir(dir_name, .{ .iterate = true });
            defer dir.close();

            var iter = dir.iterate();
            while (try iter.next()) |entry| {
                if (entry.kind != .directory and entry.kind != .sym_link) {
                    continue;
                }

                const path = try dir.realpathAlloc(allocator, entry.name);
                defer allocator.free(path);

                try fzf_stdin.print("{s}\n", .{path});
            }
        }
    }

    const project_path_raw = try fzf_proc.stdout.?.readToEndAlloc(allocator, max_fzf_output_len);
    defer allocator.free(project_path_raw);

    const project_path = std.mem.trimRight(u8, project_path_raw, "\n");

    switch (try fzf_proc.wait()) {
        .Exited => |code| {
            if (code == 130) {
                return;
            }
        },
        else => return error.UnexpectedFzfExit,
    }

    const project_name = std.fs.path.stem(project_path);

    const has_session = blk: {
        const result = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &.{ "tmux", "has-session", "-t", project_name },
        });

        switch (result.term) {
            .Exited => |code| {
                if (code == 0) {
                    break :blk true;
                }
            },
            else => {},
        }

        break :blk false;
    };

    if (!has_session) {
        _ = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &.{ "tmux", "new-session", "-d", "-s", project_name, "-c", project_path },
        });

        _ = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &.{ "tmux", "send-keys", "-t", project_name, "vim .", "C-m" },
        });

        _ = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &.{ "tmux", "new-window", "-t", project_name, "-c", project_path },
        });
    }

    {
        const window_name = try std.fmt.allocPrint(allocator, "{s}:1", .{project_name});
        defer allocator.free(window_name);

        _ = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &.{ "tmux", "select-window", "-t", window_name },
        });
    }

    if (!inside_tmux) {
        return std.process.execv(allocator, &.{ "tmux", "attach", "-t", project_name });
    } else {
        _ = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &.{ "tmux", "switch-client", "-t", project_name },
        });
    }
}
