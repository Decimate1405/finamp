import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';

import 'queue_source_helper.dart';

class PlayerScreenAppBarTitle extends StatefulWidget {

  const PlayerScreenAppBarTitle({Key? key}) : super(key: key);

  @override
  State<PlayerScreenAppBarTitle> createState() => _PlayerScreenAppBarTitleState();
}

class _PlayerScreenAppBarTitleState extends State<PlayerScreenAppBarTitle> {
  final QueueService _queueService = GetIt.instance<QueueService>();

  @override
  Widget build(BuildContext context) {

    final currentTrackStream = _queueService.getCurrentTrackStream();

    return StreamBuilder<FinampQueueItem?>(
      stream: currentTrackStream,
      initialData: _queueService.getCurrentTrack(),
      builder: (context, snapshot) {
        final queueItem = snapshot.data!;

        return Baseline(
          baselineType: TextBaseline.alphabetic,
          baseline: 0,
          child: GestureDetector(
            onTap: () => navigateToSource(context, queueItem.source),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.playingFromType(queueItem.source.type.toString()),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                Text(
                  queueItem.source.name.getLocalized(context),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
