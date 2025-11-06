import { AudioModelKit } from "../model/AudioModel";
import { RhythmModel } from "../model/RhythmModel";
import { NotificationKitUtils } from "../model/VibratorModel";


export class TapRhythmViewModel {
  private audio = new AudioModelKit();
  private vibrator = new NotificationKitUtils();
  private rhythm = new RhythmModel();

  constructor() {
    this.audio.playerInit()
  }

  bpm: number = 120;
  accuracy: number = 100;
  pulseColor: string = '#00FFAA';
  lastTapTime: number = 0;

  async onTap(uiContext: UIContext) {
    const result = this.rhythm.analyzeTap();
    this.accuracy = Math.round(result.accuracy);
    this.lastTapTime = Date.now();

    this.playClick()
    this.vibrator.startNotification(uiContext)

    // renge göre tepki
    if (this.accuracy > 90) {
      this.pulseColor = '#00FF00';
    } else if (this.accuracy > 60) {
      this.pulseColor =
        '#FFD600';
    } else {
      this.pulseColor = '#FF3B30';
    }
  }

  setBpm(bpm: number) {
    this.bpm = bpm;
    this.rhythm.setTargetBpm(bpm);
  }

  async playClick() {
    await this.audio.player();
  }
}
