import { DataManager } from "../datasource/DataManager"
import { OtpConfig } from "../otp/type";

export const getConfigs = async () => {
  const dataManager = DataManager.getInstance();
  const storeConfig = await dataManager.getAll();
  return storeConfig.map((configString) => JSON.parse(configString) as OtpConfig);
}

export const addConfig = async (config: OtpConfig) => {
  const dataManager = DataManager.getInstance();
  await dataManager.put(config.secret, JSON.stringify(config));
}