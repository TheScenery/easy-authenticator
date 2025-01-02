import { scanBarcode, scanCore } from "@kit.ScanKit";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { OtpConfig } from "../otp/type";
import { parseUrl } from "../otp/util";

@ComponentV2
export struct Header {
  @Event addNew?: (config: OtpConfig) => void

  processScanResult(value: string) {
    if (this.addNew) {
      const parsedConfig = parseUrl(value);
      if (parsedConfig) {
        this.addNew(parsedConfig);
      }
    }
  }

  async scanCode() {
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.QR_CODE],
      enableMultiMode: true,
      enableAlbum: true
    };
    try {
      const result = await scanBarcode.startScanForResult(getContext(this), options);
      hilog.info(0x0001, '[Scan QRcode]',
        `Succeeded in getting ScanResult by promise with options, result is ${JSON.stringify(result)}`);
      this.processScanResult(result.originalValue);
    } catch (error) {
      hilog.error(0x0001, '[Scan CPSample]',
        `Failed to start the scanning service. Code:${error.code}, message: ${error.message}`);
    }
  }

  build() {
    Row() {
      Column() {
        Text($r("app.string.EntryAbility_label")).fontSize(24).fontWeight(FontWeight.Bold)
      }

      Column() {
        Button() {
          SymbolGlyph($r('sys.symbol.plus')).fontSize(24).aspectRatio(1)
        }.padding(2).backgroundColor($r('sys.color.comp_background_tertiary')).onClick(this.scanCode.bind(this))
      }
    }
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: 16,
      right: 16,
      bottom: 12,
      top: 12
    })
    .border({
      width: { bottom: 2 },
      color: $r('sys.color.comp_background_tertiary'),
      style: {
        bottom: BorderStyle.Solid,
      }
    })
  }
}