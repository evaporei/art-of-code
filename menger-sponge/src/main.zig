const std = @import("std");
const rl = @import("raylib");
const Vector3 = rl.Vector3;
const Mesh = rl.Mesh;
const Model = rl.Model;

const Box = struct {
    pos: Vector3,
    size: f32,
    model: Model,

    fn init(x: f32, y: f32, z: f32, size: f32) Box {
        const pos = Vector3.init(x, y, z);
        const mesh = rl.genMeshCube(size, size, size);
        const model = rl.Model.fromMesh(mesh);
        return Box{ .pos = pos, .model = model, .size = size };
    }

    fn rotate(self: *Box) void {
        self.model.transform = self.model.transform.multiply(rl.Matrix.rotateY(1.0 * 3.14159265358979323846 / 180.0));
        self.model.transform = self.model.transform.multiply(rl.Matrix.rotateZ(1.0 * 3.14159265358979323846 / 180.0));
    }

    fn draw(self: Box) void {
        self.model.drawEx(self.pos, Vector3.init(1, 1, 1), 0.0, rl.Vector3.init(1, 1, 1), rl.Color.init(255, 203, 0, 140));
    }

    fn generate(self: Box, allocator: std.mem.Allocator) anyerror!std.ArrayList(Box) {
        var next = std.ArrayList(Box).init(allocator);

        var x: i8 = -1;
        while (x < 2) {
            var y: i8 = -1;
            while (y < 2) {
                var z: i8 = -1;
                while (z < 2) {
                    const abs = @abs(x) + @abs(y) + @abs(z);
                    if (abs > 1) {
                        const new_size = self.size / 3;
                        // zig fmt: off
                        const b = Box.init(
                            self.pos.x + @as(f32, @floatFromInt(x)) * new_size,
                            self.pos.y + @as(f32, @floatFromInt(y)) * new_size,
                            self.pos.z + @as(f32, @floatFromInt(z)) * new_size,
                            new_size
                        );
                        // zig fmt: on
                        try next.append(b);
                    }
                    z += 1;
                }
                y += 1;
            }
            x += 1;
        }

        return next;
    }
};

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    rl.setTraceLogLevel(rl.TraceLogLevel.log_error);

    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "menger sponge");
    defer rl.closeWindow(); // Close window and OpenGL context

    var camera = rl.Camera3D{
        .position = rl.Vector3.init(screenWidth / 2, screenHeight / 2, 0),
        .target = rl.Vector3.init(0, 0, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 60,
        .projection = rl.CameraProjection.camera_perspective,
    };

    rl.disableCursor(); // limit cursor to relative moment inside window
    rl.setTargetFPS(60);

    var sponge = std.ArrayList(Box).init(allocator);
    try sponge.append(Box.init(0, 0, 0, 200));

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        camera.update(rl.CameraMode.camera_first_person);

        if (rl.isKeyPressed(rl.KeyboardKey.key_j)) {
            var next = std.ArrayList(Box).init(allocator);

            for (sponge.items) |box| {
                var tmp = try box.generate(allocator);
                try next.appendSlice(tmp.items);
                tmp.deinit();
            }

            sponge.deinit();
            sponge = next;
        }

        // FIXME: rotation should be for the whole thing
        // not per box
        for ((&sponge).items) |*box| {
            box.rotate();
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        {
            camera.begin();
            defer camera.end();

            for (sponge.items) |box| {
                box.draw();
            }
        }
    }

    sponge.deinit();
}
