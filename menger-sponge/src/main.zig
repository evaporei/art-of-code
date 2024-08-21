const rl = @import("raylib");
const Vector3 = rl.Vector3;

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "menger sponge");
    defer rl.closeWindow(); // Close window and OpenGL context

    var camera = rl.Camera3D{
        .position = rl.Vector3.init(0, 0, 0),
        .target = rl.Vector3.init(screenWidth / 2, screenHeight / 2, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 60,
        .projection = rl.CameraProjection.camera_perspective,
    };

    rl.disableCursor(); // limit cursor to relative moment inside window
    rl.setTargetFPS(60);

    const cube_pos = rl.Vector3.init(screenWidth / 2, screenHeight / 2, 0);
    const cube_mesh = rl.genMeshCube(200, 200, 200);
    var cube_model = rl.Model.fromMesh(cube_mesh);

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        camera.update(rl.CameraMode.camera_first_person);

        cube_model.transform = cube_model.transform.multiply(rl.Matrix.rotateY(1.0 * 3.14159265358979323846 / 180.0));
        cube_model.transform = cube_model.transform.multiply(rl.Matrix.rotateZ(1.0 * 3.14159265358979323846 / 180.0));

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        {
            camera.begin();
            defer camera.end();

            cube_model.drawEx(cube_pos, Vector3.init(1, 1, 1), 0.0, rl.Vector3.init(1, 1, 1), rl.Color.gold);
        }
    }
}
