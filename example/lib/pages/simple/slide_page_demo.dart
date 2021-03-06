import 'package:example/example_routes.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

@FFRoute(
  name: 'fluttercandies://slidepage',
  routeName: 'SlidePage',
  description: 'Simple demo for.',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 5,
  },
)
class SlidePageDemo extends StatefulWidget {
  @override
  _SlidePageDemoState createState() => _SlidePageDemoState();
}

class _SlidePageDemoState extends State<SlidePageDemo> {
  List<String> images = <String>[
    'https://photo.tuchong.com/14649482/f/601672690.jpg',
    'https://photo.tuchong.com/17325605/f/641585173.jpg',
    'https://photo.tuchong.com/3541468/f/256561232.jpg',
    'https://photo.tuchong.com/16709139/f/278778447.jpg',
    'https://photo.tuchong.com/15195571/f/233361383.jpg',
    'https://photo.tuchong.com/5040418/f/43305517.jpg',
    'https://photo.tuchong.com/3019649/f/302699092.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SlidePage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            final String url = images[index];
            return GestureDetector(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Hero(
                  tag: url,
                  child: ExtendedImage.network(
                    url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                    Routes.fluttercandiesSlidepageitem,
                    arguments: <String, dynamic>{
                      'url': url,
                    });
              },
            );
          },
          itemCount: images.length,
        ),
      ),
    );
  }
}

@FFRoute(
  name: 'fluttercandies://slidepageitem',
  routeName: 'SlidePageItem',
  description: 'Simple demo for.',
  argumentNames: <String>['url'],
  argumentTypes: <String>['String'],
  pageRouteType: PageRouteType.transparent,
)
class SlidePage extends StatefulWidget {
  const SlidePage({this.url});
  final String url;
  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ExtendedImageSlidePage(
        key: slidePagekey,
        child: GestureDetector(
          child: ExtendedImage.network(
            widget.url,
            enableSlideOutPage: true,

            ///make hero better when slide out
            heroBuilderForSlidingPage: (Widget result) {
              return Hero(
                tag: widget.url,
                child: result,
                flightShuttleBuilder: (BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext) {
                  final Hero hero = (flightDirection == HeroFlightDirection.pop
                      ? fromHeroContext.widget
                      : toHeroContext.widget) as Hero;
                  return hero.child;
                },
              );
            },
          ),
          onTap: () {
            slidePagekey.currentState.popPage();
            Navigator.pop(context);
          },
        ),
        slideAxis: SlideAxis.both,
        slideType: SlideType.onlyImage,
      ),
    );
  }
}
