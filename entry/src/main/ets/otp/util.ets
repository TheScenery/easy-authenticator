import { OtpConfig } from "./type";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { url } from "@kit.ArkTS";

// otpauth://totp/GitHub:evilsophietheking?secret=ECX3VKG4XX2D5V55&issuer=GitHub
export const parseUrl = (urlString: string): OtpConfig | null => {
  hilog.info(0x0001, '[Parse Auth Url]',
    `The scaned url is: ${urlString}`);
  const parsedUrl = url.URL.parseURL(urlString);
  const type = parsedUrl.hostname.toUpperCase();
  const label = parsedUrl.pathname.substring(1);
  const secret = parsedUrl.params.get("secret")
  const issuer = parsedUrl.params.get("issuer")

  if (type !== "TOTP") {
    throw new Error(`Not support auth type: ${type}`);
  }
  if (!secret) {
    throw new Error("Can not extract secret");
  }
  if (!issuer) {
    throw new Error("Can not extract issuer");
  }


  return {
    type: "TOTP",
    label,
    secret,
    issuer,
    algorithm: 'SHA1',
    digits: 6,
    period: 30,
  }
}