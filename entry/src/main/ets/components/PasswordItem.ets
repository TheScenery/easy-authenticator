import UserAuthIcon from "@ohos.userIAM.userAuthIcon"
import { TextReaderIcon } from "@hms.ai.textReader"

@Preview
@Component
export struct PasswordItem {
  build() {
    Column() {
      Row(){
        Column(){
          Text("Github").fontWeight(FontWeight.Medium).fontSize(16)
          Text("TheScenery").fontSize(14).fontColor($r('sys.color.font_secondary'))
          Text("123 456").fontWeight(FontWeight.Bold).fontSize(18).fontColor($r('sys.color.font_emphasize'))
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
      .margin({top: 8})
    }
    .padding(16)
  }
}