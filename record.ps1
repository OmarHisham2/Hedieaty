# Set variables
$DeviceSize = "1080x2424"

$ON_DEVICE_OUTPUT_FILE = "/sdcard/test_video.mp4"
$OUTPUT_VIDEO = "test_video.mp4"
$DRIVER_PATH = "./test/test_driver/integration_test_driver.dart"
$TEST_PATH = "integration_test/new_e2e_test.dart"
$DeviceId = "emulator-5554"
$MaxRecordingTime = 60  # Time limit in seconds

# Record the screen on the device
Start-Process -NoNewWindow -FilePath adb -ArgumentList "shell screenrecord --time-limit $MaxRecordingTime --size $DeviceSize $ON_DEVICE_OUTPUT_FILE" -PassThru

# Run the Flutter drive test
flutter drive --device-id=$DeviceId --driver=$DRIVER_PATH --target=$TEST_PATH

# Pull the video file from the device
adb pull $ON_DEVICE_OUTPUT_FILE $OUTPUT_VIDEO