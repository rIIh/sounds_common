import 'package:meta/meta.dart';
import 'package:sounds_common/src/media_format/native_media_formats.dart';

import 'package:sounds_platform_interface/sounds_platform_interface.dart';

import 'well_know_media_formats.dart';

abstract class MediaFormat {
  /// The [name] of the [MediaFormat].
  /// The [name] MUST be of the form container/codec (not all lower case)
  /// e.g.
  /// ogg/vorbis
  ///
  /// The [name] is used to compare [MediaFormats]
  ///
  /// For MediaFormats that don't have a container (e.g PCM) then
  /// the name should just be the codec
  /// e.g.
  /// pcm
  final String name;
  final int sampleRate;
  final int numChannels;
  final int bitRate;

  const MediaFormat.detail({
    @required this.name,
    this.sampleRate = 16000,
    this.numChannels = 1,
    this.bitRate = 16000,
  });

  /// Returns the commonly used file extension for this MediaFormat
  /// e.g. 'mp3'
  String get extension;

  /// Only [MediaFormat]s that natively supported decoding (playback) by the current platform should return
  /// true.
  Future<bool> get isNativeDecoder => NativeMediaFormats().isNativeDecoder(this);

  /// Only [MediaFormats] that natively supported encoding (recording) by the current platform should return
  /// true.
  Future<bool> get isNativeEncoder => NativeMediaFormats().isNativeEncoder(this);

  @override
  bool operator ==(covariant MediaFormat other) {
    return (name == other.name &&
        sampleRate == other.sampleRate &&
        numChannels == other.numChannels &&
        bitRate == other.bitRate);
  }
}

class MediaFormatHelper {
  /// Creates a MediaFormatProxy from a mediaFormat.
  static MediaFormatProxy generate(MediaFormat mediaFormat) {
    var proxy = MediaFormatProxy();
    proxy.name = mediaFormat.name;
    proxy.bitRate = mediaFormat.bitRate;
    proxy.numChannels = mediaFormat.numChannels;
    proxy.sampleRate = mediaFormat.sampleRate;

    /// We pass these as pigeon doesn't support contants.
    proxy.adtsAac = WellKnownMediaFormats.adtsAac.name;
    proxy.capOpus = WellKnownMediaFormats.cafOpus.name;
    proxy.mp3 = WellKnownMediaFormats.mp3.name;
    proxy.oggOpus = WellKnownMediaFormats.oggOpus.name;
    proxy.oggVorbis = WellKnownMediaFormats.oggVorbis.name;
    proxy.pcm = WellKnownMediaFormats.pcm.name;

    return proxy;
  }

  static MediaFormatProxy consts() {
    return generate(_MediaFormatConsts());
  }
}

/// Used to pass the set of constants down to the platform.
class _MediaFormatConsts extends MediaFormat {
  _MediaFormatConsts() : super.detail(name: 'hack');

  @override
  String get extension => throw UnimplementedError();

  @override
  Future<bool> get isNativeDecoder => throw UnimplementedError();

  @override
  Future<bool> get isNativeEncoder => throw UnimplementedError();
}
