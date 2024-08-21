const rl = @import("raylib");
const Vector3 = rl.Vector3;
const Mesh = rl.Mesh;
const Model = rl.Model;

const Box = struct {
    pos: Vector3,
    model: Model,

    fn init(x: f32, y: f32, z: f32) Box {
        const pos = Vector3.init(x, y, z);
        const mesh = rl.genMeshCube(200, 200, 200);
        const model = rl.Model.fromMesh(mesh);
        return Box{ .pos = pos, .model = model };
    }

    fn rotate(self: *Box) void {
        self.model.transform = self.model.transform.multiply(rl.Matrix.rotateY(1.0 * 3.14159265358979323846 / 180.0));
        self.model.transform = self.model.transform.multiply(rl.Matrix.rotateZ(1.0 * 3.14159265358979323846 / 180.0));
    }

    fn draw(self: *Box) void {
        self.model.drawEx(self.pos, Vector3.init(1, 1, 1), 0.0, rl.Vector3.init(1, 1, 1), rl.Color.gold);
    }
};

pub fn main() anyerror!void {
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

    var box = Box.init(0, 0, 0);

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        camera.update(rl.CameraMode.camera_first_person);

        box.rotate();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        {
            camera.begin();
            defer camera.end();

            box.draw();
        }
    }
}
