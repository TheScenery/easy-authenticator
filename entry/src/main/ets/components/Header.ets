@Component
export struct Header {
  build() {
    Row() {
      Column() {
        Text("EasyAuthenticator").fontSize(24).fontWeight(FontWeight.Bold)
      }

      Column() {
        Button() {
          Image($r('sys.media.ohos_ic_public_add')).height(24).aspectRatio(1)
        }.padding(2).backgroundColor($r('sys.color.comp_background_tertiary'))
      }
    }
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 16, right: 16, bottom: 14, top: 14 })
    .border({
      width: { bottom: 2 },
      color: $r('sys.color.comp_background_tertiary'),
      style: {
        bottom: BorderStyle.Solid,
      }
    })
  }
}