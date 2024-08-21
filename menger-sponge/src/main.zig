const rl = @import("raylib");

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

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        camera.update(rl.CameraMode.camera_first_person);

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        {
            camera.begin();
            defer camera.end();

            rl.drawCube(rl.Vector3.init(screenWidth / 2, screenHeight / 2, 0), 200, 200, 200, rl.Color.gold);
        }
    }
}
