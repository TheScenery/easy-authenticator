import localUnitTest from './LocalUnit.test';
import otpTestFunction from './otp.test';

export default function testsuite() {
  localUnitTest();
  otpTestFunction();
}