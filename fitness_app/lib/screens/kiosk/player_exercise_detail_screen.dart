import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Keep for convertUrlToId utility
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../models/day_exercise.dart';
import '../../utils/theme.dart';
import '../../l10n/app_localizations.dart';

class PlayerExerciseDetailScreen extends StatefulWidget {
  final DayExercise exercise;

  const PlayerExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<PlayerExerciseDetailScreen> createState() => _PlayerExerciseDetailScreenState();
}

class _PlayerExerciseDetailScreenState extends State<PlayerExerciseDetailScreen> {
  // New playback controllers
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  final YoutubeExplode _yt = YoutubeExplode();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (widget.exercise.youtubeUrl == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final videoId = YoutubePlayer.convertUrlToId(widget.exercise.youtubeUrl!);
      if (videoId == null) throw Exception('Invalid YouTube URL');

      // Get video manifest (stream info)
      var manifest = await _yt.videos.streamsClient.getManifest(videoId);
      var streamInfo = manifest.muxed.withHighestBitrate();

      // Initialize video player with direct stream URL
      _videoController = VideoPlayerController.networkUrl(streamInfo.url);
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not play video: $e';
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.exerciseName ?? 'التمرين'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Video Player Section
            Container(
              height: 250,
              color: Colors.black,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: AppTheme.error, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                'عذراً، لا يمكن تشغيل الفيديو',
                                style: TextStyle(color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        )
                      : _chewieController != null
                          ? Chewie(controller: _chewieController!)
                          : const Center(
                              child: Icon(
                                Icons.videocam_off_outlined,
                                size: 64,
                                color: AppTheme.textSecondary,
                              ),
                            ),
            ),

            // Exercise Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Exercise Name Header
                   Text(
                     widget.exercise.exerciseName ?? 'التمرين',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                       color: AppTheme.primaryColor,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   const SizedBox(height: 16),

                   // Notes (if any)
                   if (widget.exercise.notes != null && widget.exercise.notes!.isNotEmpty) ...[
                     Container(
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: AppTheme.primaryColor.withOpacity(0.1),
                         borderRadius: BorderRadius.circular(8),
                         border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                       ),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
                           const SizedBox(width: 8),
                           Expanded(
                             child: Text(
                               widget.exercise.notes!,
                               style: const TextStyle(fontSize: 16),
                             ),
                           ),
                         ],
                       ),
                     ),
                     const SizedBox(height: 24),
                   ],

                   // Sets & Reps Table
                   Text(
                     l10n?.setDetails ?? 'تفاصيل المجموعات',
                     style: Theme.of(context).textTheme.titleLarge,
                   ),
                   const SizedBox(height: 12),
                   _buildSetsList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetsList(BuildContext context) {
    if (widget.exercise.sets.isEmpty) {
      return Center(
        child: Text(
          'لا توجد مجموعات محددة',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.exercise.sets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final set = widget.exercise.sets[index];
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.black,
              child: Text('${index + 1}'),
            ),
            title: Text(
              '${set.reps} تكرار',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: set.weight != null && set.weight! > 0 
                ? Text('${set.weight} كغ') 
                : null,
            trailing: Checkbox(
              value: false, 
              onChanged: (val) {
                // Interactive checklist logic (local state)
              },
              activeColor: AppTheme.success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        );
      },
    );
  }
}
