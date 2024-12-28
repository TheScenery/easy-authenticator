import { describe, expect, it } from '@ohos/hypium'
import { getCode } from '../main/ets/otp/otp'

export default function otpTestFunction() {
  describe("otpTestFunction", () => {
    it("testGenerateCode", 0, () => {
      const result = getCode();
      expect(result).assertEqual(123456)
    })
  })
}