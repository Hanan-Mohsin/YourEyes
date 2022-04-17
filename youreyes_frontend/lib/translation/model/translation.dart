class Translation{


  final String text;
  final Map<String,String> audioMap = {
                                      'turn right':'assets/TurnRight2.m4a',
                                      'turn left': 'assets/TurnLeft2.m4a',
                                      'keep right':'assets/KeepRight.m4a',
                                      'keep left': 'assets/KeepLeft.m4a',
                                      'northwest':'assets/NorthWest2.m4a',
                                      'southwest':'assets/SouthWest2.m4a',
                                      'roundabout 1st':'assets/Roundabout1.m4a',
                                      'roundabout 2nd':'assets/Roundabout2.m4a',
                                      'roundabout 3rd':'assets/Roundabout3.m4a',
                                      'roundabout 4th':'assets/Roundabout4.m4a',
                                      'arrived right':'assets/ArrivedRight.m4a',
                                      'arrived left':'assets/ArrivedLeft.m4a',
                                      'continue':'assets/Continue.m4a',
                                      };

  Translation({required this.text});
}
