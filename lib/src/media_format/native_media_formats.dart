import 'package:sounds_common/sounds_common.dart';
import 'package:sounds_platform_interface/sounds_platform_interface.dart';

import 'adts_aac_media_format.dart';

/// Provides a means to determine the list of natively supported MediaFormats
/// on the current OS and sdk verison.
///
/// Android:
/// For the list of supported encoders/decoders:
/// https://developer.android.com/guide/topics/media/media-formats
///
class NativeMediaFormats implements MediaProvider {
  static final _self = NativeMediaFormats._internal();

  /// Factory constructors
  factory NativeMediaFormats() => _self;

  NativeMediaFormats._internal() {
    _register();
  }

  List<MediaFormat> _decoders;

  /// The set of decoders we support on this OS/SDK version
  /// for playback.
  @override
  Future<List<MediaFormat>> get decoders async {
    if (_decoders == null) {
      var response = await SoundsToPlatformApi()
          .getNativeDecoderFormats(MediaFormatHelper.consts());

      _decoders = _mapNameToFormat(response.mediaFormats);
    }
    return _decoders;
  }

  List<MediaFormat> _encoders;

  /// The set of encoders we support on this OS/SDK version
  /// for recording.
  @override
  Future<List<MediaFormat>> get encoders async {
    if (_encoders == null) {
      var response = await SoundsToPlatformApi()
          .getNativeEncoderFormats(MediaFormatHelper.consts());

      _encoders = _mapNameToFormat(response.mediaFormats);
    }
    return _encoders;
  }

  /// list of known [MediaFormats]. Thes formats may not be natively
  /// supported on every platform.
  ///
  /// To determine if a [MediaFormat] is natively supported on your
  /// OS/SDK version call [MediaFormat.isNativeEncoder] or
  /// [MediaFormat.isNativeDecoder].
  ///
  /// Use [encoders] and [decoders] to get a list of natively
  /// supported [MediaFormats].
  List<MediaFormat> get mediaFormats => _mediaFormats;

  static List<MediaFormat> get _mediaFormats => [
        AdtsAacMediaFormat(),
        CafOpusMediaFormat(),
        PCMMediaFormat(),
        OggOpusMediaFormat(),
        OggVorbisMediaFormat(),
        MP3MediaFormat(),
        PCMMediaFormat()
      ];

  /// Returns true if the [mediaFormat] is natively supported
  /// on the current OS and SDK version.
  Future<bool> isNativeDecoder(MediaFormat mediaFormat) async {
    for (var native in await decoders) {
      if (mediaFormat.name == native.name) {
        return true;
      }
    }
    return false;
  }

  /// Returns true if the [mediaFormat] is natively supported
  /// on the current OS and SDK version.
  Future<bool> isNativeEncoder(MediaFormat mediaFormat) async {
    for (var native in await encoders) {
      if (mediaFormat.name == native.name) {
        return true;
      }
    }
    return false;
  }

  /// This method registers the set of native media formats
  /// to the [MediaFormatManager].
  ///
  /// This method also registered the [NativeDurationProvider].
  void _register() {
    /// add the set of native codecs.
    for (var mediaFormat in _mediaFormats) {
      MediaFormatManager().register(mediaFormat);
    }
  }

  List<MediaFormat> _mapNameToFormat(List mediaFormats) {
    var mapped = <MediaFormat>[];

    for (var name in mediaFormats) {
      if (name == AdtsAacMediaFormat().name) {
        mapped.add(AdtsAacMediaFormat());
      }

      if (name == MP3MediaFormat().name) {
        mapped.add(MP3MediaFormat());
      }
      if (name == PCMMediaFormat().name) {
        mapped.add(PCMMediaFormat());
      }
      if (name == CafOpusMediaFormat().name) {
        mapped.add(CafOpusMediaFormat());
      }
      if (name == OggOpusMediaFormat().name) {
        mapped.add(OggOpusMediaFormat());
      }
      if (name == OggVorbisMediaFormat().name) {
        mapped.add(OggVorbisMediaFormat());
      }
    }
    return mapped;
  }
}
