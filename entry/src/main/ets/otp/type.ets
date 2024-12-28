export interface OtpConfig {
  type: 'TOTP';
  label: string;
  secret: string;
  issuer: string;
  algorithm: 'SHA1';
  digits: number;
  period: number;
}