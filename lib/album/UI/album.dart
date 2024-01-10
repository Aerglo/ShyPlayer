import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shy_player/album/cubit/album_cubit.dart';
import 'package:get/get.dart';
import 'package:shy_player/home/UI/home_widgets.dart';

class Album extends StatelessWidget {
  const Album({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 12, top: 30),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    QueryArtworkWidget(
                      size: 500,
                      quality: 100,
                      format: ArtworkFormat.PNG,
                      artworkWidth: MediaQuery.sizeOf(context).width / 3 - 24,
                      artworkHeight: MediaQuery.sizeOf(context).width / 3 - 24,
                      artworkBorder: BorderRadius.circular(20),
                      id: BlocProvider.of<AlbumCubit>(context).albumModel.id,
                      type: ArtworkType.ALBUM,
                      nullArtworkWidget: Container(
                        height: MediaQuery.sizeOf(context).width / 3 - 24,
                        width: MediaQuery.sizeOf(context).width / 3 - 24,
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      child: Column(
                        children: [
                          Text(
                            BlocProvider.of<AlbumCubit>(context)
                                .albumModel
                                .album,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '- ${BlocProvider.of<AlbumCubit>(context).albumModel.artist ?? "Unknown artist"} -',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '- ${BlocProvider.of<AlbumCubit>(context).albumModel.numOfSongs} Songs -',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Divider(
                    color: Colors.white.withOpacity(0.5),
                    thickness: 2.0,
                  ),
                ),
              ),
              Expanded(
                child: songListWidget(
                  context,
                  BlocProvider.of<AlbumCubit>(context).songList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
