// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grootmusic/controllers/song_properties.dart';
import 'package:grootmusic/model/songslist.dart';
import 'package:grootmusic/views/favourites_screen.dart';
import 'package:grootmusic/views/songs_screen.dart';
import 'package:grootmusic/widgets/song_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String refresh = 'Allow Media access';

Future askPermission() async {
  PermissionStatus status = await Permission.storage.request();
  if (status.isDenied == true) {
    askPermission();
  } else {
    return true;
  }
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  final screens = [FavScreen()];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final _audioPlayer = AudioPlayer();
  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);

  var selectedIndex;

  @override
  void initState() {
    super.initState();

    askPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200,
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const _CustomAppBar(),

        // bottomNavigationBar: BottomNavyBar(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   backgroundColor: Colors.deepPurple,
        //   selectedIndex: currentIndex,
        //   iconSize: 25,
        //   showElevation: true,
        //   itemCornerRadius: 40,
        //   curve: Curves.easeIn,
        //   onItemSelected: (index) => setState(() => currentIndex = index),
        //   items: <BottomNavyBarItem>[
        //     BottomNavyBarItem(
        //       icon: Icon(Iconsax.home),
        //       title: Text('Home'),
        //       activeColor: Colors.white,
        //       textAlign: TextAlign.center,
        //     ),
        //     BottomNavyBarItem(
        //       icon: Icon(Iconsax.heart),
        //       title: Text('Favourites'),
        //       activeColor: Colors.amber,
        //       textAlign: TextAlign.center,
        //     ),
        //   ],
        // ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              const _DisMusic(),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: SectionHeader(title: 'Trending Music'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SongCard(), //------------------------Song Card
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: SectionHeader(title: 'Discover Music'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<SongModel>>(
                      future: _audioQuery.querySongs(
                          sortType: SongSortType.DISPLAY_NAME,
                          uriType: UriType.EXTERNAL,
                          path: 'YMusic',
                          ignoreCase: false),
                      builder: (context, item) {
                        if (item.data == null)
                          return const CircularProgressIndicator();

                        if (item.data!.isEmpty)
                          return Column(
                            children: [
                              const Text("Musics not found!"),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      askPermission();
                                      if (refresh == 'Allow Media access') {
                                        refresh = 'Refresh';
                                      }
                                    });
                                  },
                                  child: BlurryContainer(
                                    height: 40,
                                    width: 200,
                                    // ignore: sort_child_properties_last
                                    child: Center(
                                      child: Text(
                                        refresh.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    blur: 7,
                                    elevation: 1,
                                    color: Colors.purple.withOpacity(0.3),
                                  ))
                            ],
                          );
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: item.data!.length,
                            itemBuilder: (context, index) {
                              SongList.SongsSkip.add(item.data);
                              SongsProperties.musicData = item.data!;
                              return InkWell(
                                onTap: () {
                                  // SongList.artistL
                                  //     .add(item.data![index].id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongsScreen(
                                          lislen: item.data!.length,
                                          songId: index,
                                          songModel: item.data![index],
                                          audioPlayer: _audioPlayer,
                                          ids: item.data![index].id,
                                        ),
                                      ));
                                },
                                child: Container(
                                  height: 75,
                                  margin:
                                      EdgeInsets.only(bottom: 10, right: 20),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color:
                                          Colors.deepPurple.withOpacity(0.7)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        QueryArtworkWidget(
                                          id: item.data![index].id,
                                          type: ArtworkType.AUDIO,
                                          artworkFit: BoxFit.fitHeight,
                                          artworkWidth: 50,
                                          artworkHeight: 50,
                                          artworkBorder:
                                              BorderRadius.circular(15),
                                          artworkClipBehavior: Clip.antiAlias,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.data![index].title,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              Text(
                                                item.data![index].artist
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              // SongList.artistL
                                              //     .add(item.data![index].id);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SongsScreen(
                                                      lislen: item.data!.length,
                                                      songId: index,
                                                      songModel:
                                                          item.data![index],
                                                      audioPlayer: _audioPlayer,
                                                      ids: item.data![index].id,
                                                    ),
                                                  ));
                                            },
                                            icon: const Icon(
                                              Icons.play_circle,
                                              color: Colors.white,
                                            ))
                                      ]),
                                ),
                              );
                            });
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DisMusic extends StatelessWidget {
  const _DisMusic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController search = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome,",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Enjoy your favourite Music",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          TextFormField(
            textInputAction: TextInputAction.search,
            controller: search,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: "Search",
              prefixIcon: Icon(Iconsax.search_normal),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey.shade600),
            ),
          )
        ],
      ),
    );
  }
}

class _CustomBottomNavbar extends StatelessWidget {
  _CustomBottomNavbar({
    this.currentIndex,
    Key? key,
  }) : super(key: key);
  var currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => currentIndex = index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.deepPurple.shade800,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home_14), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.heart), label: 'Favourites'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.play_circle), label: 'Play'),
          // BottomNavigationBarItem(
          //     icon: Icon(Iconsax.profile_circle), label: 'Home'),
        ]);
  }
}

class _CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Icon(
        Icons.grid_view_rounded,
        size: 28,
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://cdn-icons-png.flaticon.com/512/4140/4140048.png"),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
