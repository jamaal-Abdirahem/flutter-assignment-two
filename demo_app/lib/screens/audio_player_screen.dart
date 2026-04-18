import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  final TextEditingController _urlController = TextEditingController(
    text:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  );

  StreamSubscription<Object?>? _playbackEventSub;
  String? _errorText;
  String? _sourceLabel;

  @override
  void initState() {
    super.initState();

    _playbackEventSub = _player.playbackEventStream.listen(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        if (!mounted) return;
        setState(() {
          _errorText = error.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    _playbackEventSub?.cancel();
    _urlController.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadUrlAndPlay() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _errorText = 'Please enter an audio URL.';
      });
      return;
    }

    setState(() {
      _errorText = null;
      _sourceLabel = url;
    });

    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = 'Could not play URL: $e';
      });
    }
  }

  Future<void> _pickFileAndPlay() async {
    setState(() {
      _errorText = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        withData: kIsWeb,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      setState(() {
        _sourceLabel = file.name;
      });

      if (kIsWeb) {
        final bytes = file.bytes;
        if (bytes == null) {
          setState(() {
            _errorText = 'Selected file has no data (web).';
          });
          return;
        }

        final uri = Uri.dataFromBytes(bytes);
        await _player.setUrl(uri.toString());
        await _player.play();
        return;
      }

      final path = file.path;
      if (path == null || path.isEmpty) {
        setState(() {
          _errorText = 'Selected file has no path.';
        });
        return;
      }

      await _player.setFilePath(path);
      await _player.play();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = 'Could not pick/play file: $e';
      });
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'External audio URL',
                hintText: 'https://example.com/audio.mp3',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _loadUrlAndPlay,
                    icon: const Icon(Icons.link),
                    label: const Text('Play URL'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFileAndPlay,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Audio'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_sourceLabel != null)
              Text(
                'Source: $_sourceLabel',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (_errorText != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],

            const SizedBox(height: 30),

            // Play/Pause row
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final processingState = state?.processingState;
                final playing = state?.playing ?? false;

                final isLoading = processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering;

                Widget child;
                if (isLoading) {
                  child = const SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  );
                } else if (playing) {
                  child = IconButton(
                    iconSize: 44,
                    onPressed: _player.pause,
                    icon: const Icon(Icons.pause_circle_filled),
                  );
                } else {
                  child = IconButton(
                    iconSize: 44,
                    onPressed: _player.play,
                    icon: const Icon(Icons.play_circle_filled),
                  );
                }

                return Align(
                  alignment: Alignment.center,
                  child: child,
                );
              },
            ),

            const SizedBox(height: 12),

            // Seek bar + time labels (matches assignment-style UI)
            StreamBuilder<Duration?>(
              stream: _player.durationStream,
              builder: (context, durationSnapshot) {
                final duration = durationSnapshot.data ?? Duration.zero;

                return StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (context, positionSnapshot) {
                    final position = positionSnapshot.data ?? Duration.zero;
                    final safePosition = position > duration ? duration : position;

                    return Column(
                      children: [
                        Slider(
                          activeColor: primary,
                          inactiveColor: primary.withValues(alpha: 0.25),
                          value: duration.inMilliseconds == 0
                              ? 0
                              : safePosition.inMilliseconds
                                  .clamp(0, duration.inMilliseconds)
                                  .toDouble(),
                          min: 0,
                          max: duration.inMilliseconds == 0
                              ? 1
                              : duration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            final target = Duration(milliseconds: value.round());
                            _player.seek(target);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(safePosition)),
                              Text(_formatDuration(duration)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
