import { TapRhythmViewModel } from '../viewmodel/TapRhythmViewModel ';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private contextUI: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  context = this.getUIContext().getHostContext() as common.UIAbilityContext
  private vm =new TapRhythmViewModel(this.context)

  private titleHeight :number = 20;
  private textHeight:number = 20;
  private buttonHeight:number = 40;
  private totalSize: number = 240;
  private canvasSize: number = this.totalSize - this.titleHeight - this.textHeight - this.buttonHeight;
  private center: number = this.canvasSize / 2;

  aboutToAppear() {

    this.vm.setBpm(120);

  }

  build() {
    Column() {
      Text($r('app.string.title')).fontSize(14).fontColor('#FFFFFF')
      Canvas(this.contextUI)
        .width(this.canvasSize)
        .height(this.canvasSize)
        .onReady(() => {
          const drawFrame = () => {
            this.contextUI.clearRect(0, 0, this.canvasSize, this.canvasSize);

            const radius = this.canvasSize / 2 - 10;
            const now = Date.now();
            const elapsed = now - this.vm.lastTapTime;

            // Pulse animation
            const alpha = Math.max(0, 1 - elapsed / 500);
            const pulseRadius = 20 * alpha;


            this.contextUI.beginPath();
            this.contextUI.arc(this.center, this.center, radius - 2, 0, 2 * Math.PI);
            this.contextUI.strokeStyle = Color.White;
            this.contextUI.lineWidth = 3;
            this.contextUI.stroke();

            // Pulse circle
            if (elapsed < 500) {
              const color = this.vm.pulseColor.replace('#', '');
              const r = parseInt(color.substring(0, 2), 16);
              const g = parseInt(color.substring(2, 4), 16);
              const b = parseInt(color.substring(4, 6), 16);
              this.contextUI.strokeStyle = `rgba(${r},${g},${b},${alpha})`;
              this.contextUI.lineWidth = 6;
              this.contextUI.beginPath();
              this.contextUI.arc(this.center, this.center, radius - 20 + pulseRadius, 0, 2 * Math.PI);
              this.contextUI.stroke();
            }


            this.contextUI.fillStyle = Color.White;
            this.contextUI.font = '12px Arial';
            this.contextUI.textAlign = 'center';

            const bpmY = this.canvasSize - 40;
            const accuracyY = this.canvasSize - 25;
            this.contextUI.fillText(`BPM: ${this.vm.bpm}`, this.center, bpmY);
            this.contextUI.fillText(`Accuracy: ${this.vm.accuracy}%`, this.center, accuracyY);

          }
          setInterval(drawFrame, 1000/60);
        })
        .backgroundColor($r('app.color.canvas'))
        .borderRadius(120)
        .onClick(async () => {
          this.vm.playClick(this.context)
          await this.vm.onTap(this.getUIContext(),this.context);
        })
    Row(){
      Button('BPM +10').onClick(() => {
        this.vm.setBpm(this.vm.bpm + 10);
      }).width(70).height(30).fontSize(8)
      Button('BPM -10').onClick(() => {
        this.vm.setBpm(this.vm.bpm - 10);
      }).width(70).height(30).fontSize(8)
    } .width(this.totalSize)
    .height(this.buttonHeight).alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)

    }.width('100%').height('100%').alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center)
  }
}