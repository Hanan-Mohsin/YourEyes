class Translation{


  final String text;
  final Map<String,String> audioMap = {'trial':'assets/Background-1.mp3',
                                      'right':'assets/Voice 004.mp3',
                                      'left': 'assets/Voice 004.mp3',
                                      'northwest':'assets/Voice 004.mp3',
                                      'southwest':'assets/Voice 004.mp3',
                                      'arrived':'assets/Voice 004.mp3'};

  Translation({required this.text});
}