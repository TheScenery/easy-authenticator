import { generate } from "../otp/otp"
import { OtpConfig, OtpResult } from "../otp/type";
import { formatCode } from "../utils/formatter"

@Preview
@ComponentV2
export struct PasswordItem {
  intervalId: number | null = null;
  @Param @Require config: OtpConfig;
  @Param @Require time: number;

  @Computed
  get otpResult(): OtpResult {
    return generate(this.config, this.time);
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.config.issuer).fontWeight(FontWeight.Medium).fontSize(16)
          Text(this.config.label).fontSize(14).fontColor($r('sys.color.font_secondary')).margin({ top: 2 })
          Text(formatCode(this.otpResult.code))
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
            .fontColor($r('sys.color.font_emphasize')).margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)

        Column() {
          Image($r('sys.media.ohos_ic_public_arrow_right')).width(24)
        }
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Progress({
          value: this.otpResult.current,
          total: this.otpResult.total,
        }).backgroundColor($r("sys.color.comp_background_emphasize")).color($r("sys.color.gray_04"))
      }
      .margin({ top: 8 })
    }
    .padding(16)
  }
}