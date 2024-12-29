import { OtpConfig } from "./type"
import { cryptoFramework } from "@kit.CryptoArchitectureKit";
import { buffer, util } from "@kit.ArkTS";

const getConfig = (): OtpConfig => {
  // otpauth://totp/GitHub:evilsophietheking?secret=ECX3VKG4XX2D5V55&issuer=GitHub
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

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  return symKey;
}

const getHash = (message: string, macAlgName: string, keyString: string) => {
  let keyData = new Uint8Array(buffer.from(keyString, 'hex').buffer);
  let key = genSymKeyByData(keyData);
  let mac = cryptoFramework.createMac(macAlgName);
  mac.initSync(key);
  // 数据量较少时，可以只做一次update，将数据全部传入，接口未对入参长度做限制
  mac.updateSync({ data: new Uint8Array(buffer.from(message, 'hex').buffer) });
  let macResult = mac.doFinalSync();
  return buffer.from(macResult.data).toString('hex')
}

const hex2dec = (s: string): number => {
  return Number(`0x${s}`);
}

const leftpad = (str: string, len: number, pad: string): string => {
  if (len + 1 >= str.length) {
    str = new Array(len + 1 - str.length).join(pad) + str;
  }
  return str;
}

const base32tohex = (base32: string): string => {
  const base32chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
  let bits = "";
  let hex = "";
  let padding = 0;

  for (let i = 0; i < base32.length; i++) {
    if (base32.charAt(i) === "=") {
      bits += "00000";
      padding++;
    } else {
      const val = base32chars.indexOf(base32.charAt(i).toUpperCase());
      bits += leftpad(val.toString(2), 5, "0");
    }
  }

  for (let i = 0; i + 4 <= bits.length; i += 4) {
    const chunk = bits.substr(i, 4);
    hex = hex + Number(`0b${chunk}`).toString(16);
  }

  switch (padding) {
    case 0:
      break;
    case 6:
      hex = hex.substr(0, hex.length - 8);
      break;
    case 4:
      hex = hex.substr(0, hex.length - 6);
      break;
    case 3:
      hex = hex.substr(0, hex.length - 4);
      break;
    case 1:
      hex = hex.substr(0, hex.length - 2);
      break;
    default:
      throw new Error("Invalid Base32 string");
  }

  return hex;
}


export const getCode = (time: number) => {
  const config = getConfig();
  const epoch = Math.round(time / 1000)
  let counter = Math.floor(epoch / config.period);
  const hmac = getHash(leftpad(counter.toString(16), 16, "0"), config.algorithm, base32tohex(config.secret))
  const offset = hex2dec(hmac.substring(hmac.length - 1));

  let otp =
    (hex2dec(hmac.substr(offset * 2, 8)) & hex2dec("7fffffff")) + "";

  return otp.substring(otp.length - 6);
}