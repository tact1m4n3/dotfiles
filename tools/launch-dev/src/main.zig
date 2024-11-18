const std = @import("std");

const MAX_FZF_OUTPUT_LEN = 100;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var env_map = try std.process.getEnvMap(allocator);
    defer env_map.deinit();

    const home_path = env_map.get("HOME") orelse return error.HomeVarNotFound;
    const inside_tmux = if (env_map.get("TMUX")) |_| true else false;

    var projects = std.ArrayList([]const u8).init(allocator);
    defer {
        for (projects.items) |project| {
            allocator.free(project);
        }
        projects.deinit();
    }

    {
        var home_dir = try std.fs.openDirAbsolute(home_path, .{});
        defer home_dir.close();

        var dev_dir = try home_dir.openDir("dev", .{ .iterate = true });
        defer dev_dir.close();

        var iter = dev_dir.iterate();
        while (try iter.next()) |entry| {
            if (entry.kind != .directory) continue;
            try projects.append(try dev_dir.realpathAlloc(allocator, entry.name));
        }
    }

    const fzf_exe = if (inside_tmux) "fzf-tmux" else "fzf";
    var fzf_proc = std.process.Child.init(&.{fzf_exe}, allocator);
    fzf_proc.stdin_behavior = .Pipe;
    fzf_proc.stdout_behavior = .Pipe;
    fzf_proc.stderr_behavior = .Pipe;

    try fzf_proc.spawn();

    const fzf_input = fzf_proc.stdin.?.writer();
    for (projects.items) |project| {
        try fzf_input.print("{s}\n", .{project});
    }

    const project_path_raw = try fzf_proc.stdout.?.readToEndAlloc(allocator, MAX_FZF_OUTPUT_LEN);
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
