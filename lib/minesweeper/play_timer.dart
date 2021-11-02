import 'dart:async';

class PlayTimer{
  late Duration interval;
  Timer? _timer;
  Duration _playTime = Duration(milliseconds: 0);

  PlayTimer({required this.interval, required Function checkTimerStop, Function? onStop, Function? onInterval}){
    startTimer(checkTimerStop: checkTimerStop, onStop: onStop, onInterval: onInterval);
  }

  void startTimer({required Function checkTimerStop, Function? onStop, Function? onInterval}){
    if(_timer != null)
      return;

    _timer = Timer.periodic(interval,
            (timer) {
              if(checkTimerStop()){
                timer.cancel();

                if(onStop != null) onStop();
              }
              else{
                var newTime = _playTime.inMilliseconds + interval.inMilliseconds;
                _playTime = Duration(milliseconds: newTime);
                if(onInterval != null) onInterval();
              }
            }
    );
  }

  String formatTimer(){
    String twoDigit(int t) => t.toString().padLeft(2, '0');
    String min = twoDigit(_playTime.inMinutes.remainder(60));
    String sec = twoDigit(_playTime.inSeconds.remainder(60));

    return '$min : $sec';
  }

  void dispose(){
    _timer?.cancel();
  }

}

