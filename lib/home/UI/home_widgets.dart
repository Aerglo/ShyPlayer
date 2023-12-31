import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shy_player/home/cubit/home_cubit.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

FlashyTabBar homeBottomNavigationBar(BuildContext context) {
  return FlashyTabBar(
    backgroundColor: Get.isDarkMode
        ? Theme.of(context).colorScheme.onBackground
        : Theme.of(context).colorScheme.background,
    selectedIndex: BlocProvider.of<HomeCubit>(context).index,
    showElevation: true,
    onItemSelected: (index) {
      BlocProvider.of<HomeCubit>(context).changeIndex(index);
    },
    items: [
      FlashyTabBarItem(
        activeColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.music_note,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: const Text('Songs'),
      ),
      FlashyTabBarItem(
        activeColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.queue_music,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: const Text('Playlist'),
      ),
      FlashyTabBarItem(
        activeColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.album,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: const Text('Album'),
      ),
      FlashyTabBarItem(
        activeColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: const Text('Artist'),
      ),
    ],
  );
}

AppBar homeAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Get.isDarkMode
        ? Theme.of(context).colorScheme.onBackground
        : Theme.of(context).colorScheme.background,
    elevation: 0,
    centerTitle: false,
    automaticallyImplyLeading: false,
    actions: [
      Padding(
        padding: const EdgeInsets.only(
          right: 15.0,
        ),
        child: IconButton(
          onPressed: BlocProvider.of<HomeCubit>(context).changeTheme,
          icon: Icon(
            Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    ],
    title: Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
      ),
      child: Text(
        'Shy Player',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
  );
}

Widget loadingWidget(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

Widget errorWidget(BuildContext context) {
  return Center(
    child: Text(
      'Error!',
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget songListWidget(BuildContext context, List<SongModel> songList) {
  if (songList.isEmpty) {
    return Center(
      child: Text(
        'Song list is empty!',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  } else {
    return ListView.builder(
      itemCount: songList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Get.isDarkMode
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).colorScheme.background,
          child: ListTile(
            onTap: () {
              BlocProvider.of<PlayCubit>(context)
                  .musicTileTapped(songList[index], index, songList, context);
            },
            title: Text(
              songList[index].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: BlocProvider.of<PlayCubit>(context).index == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
            subtitle: Text(
              songList[index].artist ?? 'Unknown Artist',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: BlocProvider.of<PlayCubit>(context).index == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
            leading: QueryArtworkWidget(
              id: songList[index].id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.onBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.music_note,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget playlistListWidget(
    BuildContext context, List<PlaylistModel> playlistList) {
  if (playlistList.isEmpty) {
    return Center(
      child: Text(
        'Playlist list is empty!',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  } else {
    return ListView.builder(
      itemCount: playlistList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Get.isDarkMode
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).colorScheme.background,
          child: ListTile(
            title: Text(
              playlistList[index].playlist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            subtitle: Text(
              '${playlistList[index].numOfSongs} songs',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            leading: QueryArtworkWidget(
              id: playlistList[index].id,
              type: ArtworkType.PLAYLIST,
              nullArtworkWidget: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.onBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.music_note,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                BlocProvider.of<PlayCubit>(context).deletePlaylist(playlistList[index].id);
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget artistListWidget(BuildContext context, List<ArtistModel> artistList) {
  if (artistList.isEmpty) {
    return Center(
      child: Text(
        'Artist list is empty!',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  } else {
    return ListView.builder(
      itemCount:
      artistList.length ~/ 3, // Change this to the number of rows you want
      itemBuilder: (context, index) {
        return Row(
          children: <Widget>[
            artistTile(index * 3, context, artistList),
            artistTile(index * 3 + 1, context, artistList),
            artistTile(index * 3 + 2, context, artistList),

          ],
        );
      },
    );
  }
}

Widget artistTile(int index, BuildContext context, List<ArtistModel> artistList) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        children: [
          QueryArtworkWidget(
            size: 500,
            quality: 100,
            format: ArtworkFormat.PNG,
            artworkWidth: MediaQuery.sizeOf(context).width / 3 - 24,
            artworkHeight: MediaQuery.sizeOf(context).width / 3 - 24,
            artworkBorder: BorderRadius.circular(20),
            id: artistList[index].id,
            type: ArtworkType.ARTIST,
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
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 3 - 24,
            child: Text(
              artistList[index].artist,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget albumListWidget(BuildContext context, List<AlbumModel> albumList) {
  if (albumList.isEmpty) {
    return Center(
      child: Text(
        'Album list is empty!',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  } else {
    return ListView.builder(
      itemCount:
          albumList.length ~/ 3, // Change this to the number of rows you want
      itemBuilder: (context, index) {
        return Row(
          children: <Widget>[
            albumTile(index * 3, context, albumList),
            albumTile(index * 3 + 1, context, albumList),
            albumTile(index * 3 + 2, context, albumList),
          ],
        );
      },
    );
  }
}

Widget albumTile(int index, BuildContext context, List<AlbumModel> albumList) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        children: [
          QueryArtworkWidget(
            size: 500,
            quality: 100,
            format: ArtworkFormat.PNG,
            artworkWidth: MediaQuery.sizeOf(context).width / 3 - 24,
            artworkHeight: MediaQuery.sizeOf(context).width / 3 - 24,
            artworkBorder: BorderRadius.circular(20),
            id: albumList[index].id,
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
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 3 - 24,
            child: Text(

              albumList[index].album,

              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget playingTile(BuildContext context) {
  return GestureDetector(
    onTap: BlocProvider.of<PlayCubit>(context).pushFromPlayingTile,
    child: Card(
      elevation: 0,
      color: Get.isDarkMode
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).colorScheme.onBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: playingTileArtwork(context),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  playingTileTitle(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  playingTileArtist(context),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          InkResponse(
            onTap: BlocProvider.of<PlayCubit>(context).seekToStart,
            onDoubleTap: BlocProvider.of<PlayCubit>(context).seekToPreviousSong,
            child: Icon(
              Icons.skip_previous_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          BlocBuilder<PlayCubit, PlayState>(
            builder: (context, state) {
              return IconButton(
                onPressed: BlocProvider.of<PlayCubit>(context).pauseAndPlay,
                icon: Icon(
                  BlocProvider.of<PlayCubit>(context).audioPlayer.playing
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
            buildWhen: (previous, current) => current is PlayPauseState,
          ),
          IconButton(
            onPressed: BlocProvider.of<PlayCubit>(context).seekToNextSong,
            icon: Icon(
              Icons.skip_next_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    ),
  );
}

String playingTileTitle(BuildContext context) {
  if (BlocProvider.of<PlayCubit>(context).songModel == null) {
    return 'No playing song in queue';
  } else {
    return BlocProvider.of<PlayCubit>(context).songModel!.title;
  }
}

String playingTileArtist(BuildContext context) {
  if (BlocProvider.of<PlayCubit>(context).songModel == null) {
    return 'No playing song in queue';
  } else {
    if (BlocProvider.of<PlayCubit>(context).songModel!.artist == null) {
      return 'Unknown Artist';
    } else {
      return BlocProvider.of<PlayCubit>(context).songModel!.artist!;
    }
  }
}

Widget playingTileArtwork(BuildContext context) {
  if (BlocProvider.of<PlayCubit>(context).songModel == null) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? Theme.of(context).colorScheme.onBackground
            : Theme.of(context).colorScheme.background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.music_note,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  } else {
    return QueryArtworkWidget(
      id: BlocProvider.of<PlayCubit>(context).songModel!.id,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).colorScheme.background,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.music_note,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
