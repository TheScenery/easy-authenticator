import { Header } from '../components/Header';
import { PasswordItem } from '../components/PasswordItem';
import { OtpConfig } from '../otp/type';

@Entry
@Component
struct Index {
  @State configs: OtpConfig[] = []

  addNew(config: OtpConfig) {
    this.configs.push(config)
  }

  build() {
    Column() {
      Header({ addNew: this.addNew.bind(this) })
      List() {
        ForEach(this.configs, (config: OtpConfig) => {
          ListItem() {
            PasswordItem({ config })
          }
        }, (config: OtpConfig) => config.secret)
      }.divider({
        strokeWidth: 2
      })
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}