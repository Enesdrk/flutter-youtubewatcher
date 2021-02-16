import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_youtube_watcher/models/channel_model.dart';
import 'package:flutter_youtube_watcher/models/video_model.dart';
import 'package:flutter_youtube_watcher/screen/LoginScreen.dart';
import 'package:flutter_youtube_watcher/screen/video_screen.dart';
import 'package:flutter_youtube_watcher/sevices/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  final String mail;
  final String password;
  var videoListArray = [];
  HomeScreen(this.mail, this.password);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Channel _channel;
  bool _isLoading = false;
  int k = 2;
  int indexcounter = 2;
  Random rnd;

  var MyList = [
    'UCRcgy6GzDeccI7dkbbBna3Q',
    'UC726J5A0LLFRxQ0SZqr2mYQ',
    'UCveZqqGewoyPiacooywP5Ig',
    'UCqYPhGiB9tkShZorfgcL2lA',
    'UCtI0Hodo5o5dUb67FeUjDeA',
    'UCzWQYUVCpZqtN93H8RR44Qw'
  ];

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel =
        await APIService.instance.fetchChannel(channelId: MyList.first);

    setState(() {
      _channel = channel;
    });
  }

  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 0.1,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(_channel.profilePictureUrl),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channel.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_channel.subscriberCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 110.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);

    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Watcher"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Log Out',
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          IconButton(
              icon: Icon(Icons.add),
              tooltip: 'List Profiles',
              onPressed: () {
                Random random = new Random();
                int randomNumber = random.nextInt(5);
                MyList[randomNumber];
                k++;
                if (randomNumber == 5) {
                  randomNumber = 0;
                }

                _initChannel();
                _loadMoreVideos();
              }),
        ],
      ),
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel.videos.length != int.parse(_channel.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {}
                return false;
              },
              child: ListView.builder(
                itemCount: k,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _buildProfileInfo();
                  }
                  Video video = _channel.videos[index - 1];
                  return _buildVideo(video);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }
}
