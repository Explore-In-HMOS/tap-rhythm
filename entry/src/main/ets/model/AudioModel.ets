import {
  WlAudioInterruptHint,
  WlAudioInterruptType,
  WlCompleteType,
  WlComponentController,
  WlLoadStatus,
  WlPlayer,
} from '@ywl5320/libwlmedia';
import { FileUtil } from '../utils/FileUtil';

export class AudioModelKit {
  private wlComponentController: WlComponentController | null = null;
  private wlPlayer: WlPlayer | null = null;
 playerInit(){
   const filesDir = getContext().filesDir;
   FileUtil.resourcesFile2SandboxFile('testvideos/click.mp3', filesDir + '/click.mp3');
    this.wlPlayer = new WlPlayer();
    this.wlPlayer.setOnMediaInfoListener({
      onPrepared: (): void => {
        this.wlPlayer?.start();
      },
      onTimeInfo: (currentTime: number, bufferTime: number): void => {

      },
      onComplete: (complete: WlCompleteType, msg: string): void => {
        if (complete == WlCompleteType.WL_COMPLETE_EOF) {

        } else if (complete == WlCompleteType.WL_COMPLETE_ERROR) {

        } else if (complete == WlCompleteType.WL_COMPLETE_HANDLE) {

        } else if (complete == WlCompleteType.WL_COMPLETE_NEXT) {

        } else if (complete == WlCompleteType.WL_COMPLETE_TIMEOUT) {

        } else if (complete == WlCompleteType.WL_COMPLETE_LOOP) {

        }
      },
      onLoadInfo: (loadStatus: WlLoadStatus, progress: number, speed: number): void => {

      },
      onFirstFrameRendered: (): void => {
      },
      onSeekFinish: (): void => {
      },
      onAudioInterrupt: (type: WlAudioInterruptType, hint: WlAudioInterruptHint) => {
      }
    });
    this.wlComponentController = new WlComponentController(this.wlPlayer);
  }

  player(){
    this.wlPlayer?.setSource(getContext(this).filesDir +'/click.mp3')
    this.wlPlayer?.prepare()
  }

}
