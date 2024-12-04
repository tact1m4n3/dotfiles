const std = @import("std");

const max_fzf_output_len = 100;

const lookup_dirs = [_][]const u8{
    "dotfiles",
    "dev",
};

const project_idents = [_][]const u8{
    ".git",
    "Cargo.toml",
    "build.zig",
    "go.mod",
    "Makefile",
    "init.lua",
};

const MAX_DEPTH = 5;

fn walk(allocator: std.mem.Allocator, dir: std.fs.Dir, writer: std.fs.File.Writer, depth: u32) !void {
    if (depth > MAX_DEPTH) return;

    var iter = dir.iterate();
    child_iter: while (try iter.next()) |entry| {
        for (project_idents) |ident| {
            if (std.mem.eql(u8, entry.name, ident)) {
                const path = try dir.realpathAlloc(allocator, ".");
                defer allocator.free(path);

                try writer.print("{s}\n", .{path});

                break :child_iter;
            }
        }
    }

    iter.reset();
    while (try iter.next()) |entry| {
        if (entry.kind != .directory)
            continue;

        var child_dir = try dir.openDir(entry.name, .{ .iterate = true });
        defer child_dir.close();

        try walk(
            allocator,
            child_dir,
            writer,
            depth + 1,
        );
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var env_map = try std.process.getEnvMap(allocator);
    defer env_map.deinit();

    const home_path = env_map.get("HOME") orelse return error.HomeVarNotFound;
    const inside_tmux = if (env_map.get("TMUX")) |_| true else false;

    var fzf_proc = std.process.Child.init(&.{"fzf"}, allocator);
    fzf_proc.stdin_behavior = .Pipe;
    fzf_proc.stdout_behavior = .Pipe;
    fzf_proc.stderr_behavior = .Pipe;

    try fzf_proc.spawn();

    {
        const fzf_stdin = fzf_proc.stdin.?.writer();

        var home_dir = try std.fs.openDirAbsolute(home_path, .{});
        defer home_dir.close();

        for (lookup_dirs) |name| {
            var child_dir = try home_dir.openDir(name, .{});
            defer child_dir.close();

            try walk(allocator, child_dir, fzf_stdin, 0);
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
