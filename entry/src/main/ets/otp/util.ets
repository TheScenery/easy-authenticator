import { OtpConfig } from "./type";
import { hilog } from "@kit.PerformanceAnalysisKit";

// otpauth://totp/GitHub:evilsophietheking?secret=ECX3VKG4XX2D5V55&issuer=GitHub
export const parseUrl = (url: string): OtpConfig | null => {
  hilog.info(0x0001, '[Parse Auth Url]',
    `The scaned url is: ${url}`);
  return {
    type: "TOTP",
    label: "GitHub:evilsophietheking",
    secret: "ECX3VKG4XX2D5V55",
    issuer: "GitHub",
    algorithm: 'SHA1',
    digits: 6,
    period: 30,
  }
}