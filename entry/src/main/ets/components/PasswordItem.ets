import { getCode } from "../otp/otp"
import { formatCode } from "../utils/formatter"

@Preview
@Component
export struct PasswordItem {
  @State time: number = Date.now();
  intervalId: number | null = null;

  render(): void {
    this.time = Date.now();
  }

  aboutToAppear(): void {
    this.render();
    this.intervalId = setInterval(() => {
      this.render();
    }, 1000)
  }

  aboutToDisappear(): void {
    if (this.intervalId !== null) {
      clearInterval(this.intervalId)
    }
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text("Github").fontWeight(FontWeight.Medium).fontSize(16)
          Text("TheScenery").fontSize(14).fontColor($r('sys.color.font_secondary')).margin({ top: 2 })
          Text(formatCode(getCode(this.time)))
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
            .fontColor($r('sys.color.font_emphasize')).margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Image($r('sys.media.ohos_ic_public_arrow_right')).width(24).aspectRatio(1)
        }
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Progress({
          value: 20,
          total: 30,
        })
      }
      .margin({ top: 8 })
    }
    .padding(16)
  }
}