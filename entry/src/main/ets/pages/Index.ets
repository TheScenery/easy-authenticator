import { Header } from '../components/Header';
import { PasswordItem } from '../components/PasswordItem';
import { OtpConfig } from '../otp/type';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { addConfig, deleteConfig, getConfigs } from '../datamodule/datamodule';

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

  async loadConfigs() {
    this.configs = await getConfigs();
  }

  aboutToAppear(): void {
    this.loadConfigs();
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

  async deleteConfig(config: OtpConfig) {
    await deleteConfig(config);
    this.loadConfigs();
  }

  async addNew(config: OtpConfig) {
    this.configs.push(config);
    await addConfig(config);
    this.loadConfigs();
  }

  @Builder
  itemEnd(config: OtpConfig) {
    Row() {
      Button() {
        SymbolGlyph($r('sys.symbol.trash')).fontSize(24)
      }
      .padding(8).backgroundColor($r("sys.color.ohos_toggle_bg_transparent"))
      .onClick(() => this.deleteConfig(config))
    }.padding(4).justifyContent(FlexAlign.SpaceEvenly)
  }

  @Builder
  buildListView() {
    List() {
      ForEach(this.configs, (config: OtpConfig) => {
        ListItem() {
          PasswordItem({ config, time: this.time })
        }.swipeAction({
          end: {
            builder: () => {
              this.itemEnd(config);
            },
          }
        })
      }, (config: OtpConfig) => config.secret)
    }.divider({
      strokeWidth: 2
    })
  }

  @Builder
  buildEmptyView() {
    Row() {
      Text($r("app.string.empty_tip"))
    }.justifyContent(FlexAlign.Center).width('100%').margin({ top: 12 })
  }

  build() {
    Column() {
      Header({ addNew: this.addNew.bind(this) })
      if (this.configs.length > 0) {
        this.buildListView()
      } else {
        this.buildEmptyView()
      }
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}