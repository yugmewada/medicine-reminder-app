import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// An image chosen by the user, held in memory only.
@immutable
class PickedImage {
  const PickedImage({required this.bytes, required this.name, this.mimeType});

  final Uint8List bytes;
  final String name;
  final String? mimeType;
}

/// Outcome of a pick. A dismissed picker is [MediaPickCancelled], not an error.
sealed class MediaPickResult {
  const MediaPickResult();
}

final class MediaPicked extends MediaPickResult {
  const MediaPicked(this.image);

  final PickedImage image;
}

final class MediaPickCancelled extends MediaPickResult {
  const MediaPickCancelled();
}

/// Why a pick failed. The app maps each case to a localized message.
enum MediaPickFailure { accessDenied, invalidImage, alreadyActive, unknown }

final class MediaPickFailed extends MediaPickResult {
  const MediaPickFailed(this.failure, {this.code});

  final MediaPickFailure failure;

  /// Raw platform error code, for diagnostics only. Never show it to users.
  final String? code;
}

/// The single image picker used across the app on Android and iOS.
///
/// Gallery only, so the app needs no camera permission:
/// - **Android:** always uses the system Photo Picker
///   (`ActivityResultContracts.PickVisualMedia`, backported to older
///   versions through Google Play services). The plugin declares no
///   `READ_MEDIA_IMAGES` or `READ_MEDIA_VIDEO` permission.
/// - **iOS 14+:** uses `PHPicker`, which needs no photo-library permission.
///
/// Depend on this abstract type so tests and previews can inject a fake.
abstract interface class MediaPicker {
  Future<MediaPickResult> pickImage({
    double maxDimension = 1024,
    int imageQuality = 85,
  });
}

/// [MediaPicker] backed by `package:image_picker`.
class PlatformMediaPicker implements MediaPicker {
  PlatformMediaPicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Forces the Android Photo Picker on Android 15 and below (Android 16+
  /// always uses it). Call once before the first pick, e.g. in `main()`.
  static void configure() {
    final implementation = ImagePickerPlatform.instance;
    if (implementation is ImagePickerAndroid) {
      implementation.useAndroidPhotoPicker = true;
    }
  }

  @override
  Future<MediaPickResult> pickImage({
    double maxDimension = 1024,
    int imageQuality = 85,
  }) async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxDimension,
        maxHeight: maxDimension,
        imageQuality: imageQuality,
        requestFullMetadata: false,
      );
      if (file == null) return const MediaPickCancelled();
      return MediaPicked(
        PickedImage(
          bytes: await file.readAsBytes(),
          name: file.name,
          mimeType: file.mimeType,
        ),
      );
    } on PlatformException catch (e) {
      return MediaPickFailed(failureFor(e.code), code: e.code);
    } catch (_) {
      return const MediaPickFailed(MediaPickFailure.unknown);
    }
  }

  /// Maps `image_picker` platform error codes to [MediaPickFailure].
  @visibleForTesting
  static MediaPickFailure failureFor(String code) => switch (code) {
    'photo_access_denied' ||
    'camera_access_denied' => MediaPickFailure.accessDenied,
    'invalid_image' => MediaPickFailure.invalidImage,
    'already_active' => MediaPickFailure.alreadyActive,
    _ => MediaPickFailure.unknown,
  };
}
