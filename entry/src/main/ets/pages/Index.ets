import { TapRhythmViewModel } from '../viewmodel/TapRhythmViewModel ';

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private vm = new TapRhythmViewModel();

  @State private titleHeight :number = 20;
  @State private textHeight:number = 20;
  @State private  buttonHeight:number = 40;
  @State private totalSize: number = 240;
  @State private canvasSize: number =  this.totalSize - this.titleHeight - this.textHeight - this.buttonHeight;
  @State private center: number = this.canvasSize / 2;

  aboutToAppear() {
    this.vm.setBpm(120);
  }

  build() {
    Column() {
      Text($r('app.string.title')).fontSize(14).fontColor('#FFFFFF')
      Canvas(this.context)
        .width(this.canvasSize)
        .height(this.canvasSize)
        .onReady(() => {
          const drawFrame = () => {
            this.context.clearRect(0, 0, this.canvasSize, this.canvasSize);

            const radius = this.canvasSize / 2 - 10;
            const now = Date.now();
            const elapsed = now - this.vm.lastTapTime;

            // Pulse animation
            const alpha = Math.max(0, 1 - elapsed / 500);
            const pulseRadius = 20 * alpha;


            this.context.beginPath();
            this.context.arc(this.center, this.center, radius - 2, 0, 2 * Math.PI);
            this.context.strokeStyle = Color.White;
            this.context.lineWidth = 3;
            this.context.stroke();

            // Pulse circle
            if (elapsed < 500) {
              const color = this.vm.pulseColor.replace('#', '');
              const r = parseInt(color.substring(0, 2), 16);
              const g = parseInt(color.substring(2, 4), 16);
              const b = parseInt(color.substring(4, 6), 16);
              this.context.strokeStyle = `rgba(${r},${g},${b},${alpha})`;
              this.context.lineWidth = 6;
              this.context.beginPath();
              this.context.arc(this.center, this.center, radius - 20 + pulseRadius, 0, 2 * Math.PI);
              this.context.stroke();
            }


            this.context.fillStyle = Color.White;
            this.context.font = '12px Arial';
            this.context.textAlign = 'center';

            const bpmY = this.canvasSize - 40;
            const accuracyY = this.canvasSize - 25;
            this.context.fillText(`BPM: ${this.vm.bpm}`, this.center, bpmY);
            this.context.fillText(`Accuracy: ${this.vm.accuracy}%`, this.center, accuracyY);

          }
          setInterval(drawFrame, 1000/60);
        })
        .backgroundColor($r('app.color.canvas'))
        .borderRadius(120)
        .onClick(async () => {
          this.vm.playClick()
          await this.vm.onTap(this.getUIContext());
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