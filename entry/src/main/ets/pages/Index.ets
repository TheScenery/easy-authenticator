import { Header } from '../components/Header';
import { PasswordItem } from '../components/PasswordItem';
import { OtpConfig } from '../otp/type';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@ComponentV2
struct Index {
  intervalId: number | null = null;
  @Local time: number = Date.now();
  @Local configs: OtpConfig[] = []

  render(): void {
    hilog.info(0x0001, '[Easy authenticator]', `regenerate otp`)
    this.time = Date.now();
  }

  onPageShow(): void {
    this.render();
    this.intervalId = setInterval(() => {
      this.render();
    }, 1000)
  }

  onPageHide(): void {
    if (this.intervalId !== null) {
      clearInterval(this.intervalId)
    }
  }

  addNew(config: OtpConfig) {
    this.configs.push(config)
  }

  build() {
    Column() {
      Header({ addNew: this.addNew.bind(this) })
      List() {
        ForEach(this.configs, (config: OtpConfig) => {
          ListItem() {
            PasswordItem({ config, time: this.time })
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