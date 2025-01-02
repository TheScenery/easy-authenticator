import { common } from "@kit.AbilityKit";
import { distributedKVStore } from "@kit.ArkData";
import { BusinessError } from "@kit.BasicServicesKit";

const KEY_PREFIX = 'otp-config--';

export class DataManager {
  private static instance: DataManager;
  private storeId: string = 'config_store'
  private kvManager: distributedKVStore.KVManager | null = null;
  private kvStore: distributedKVStore.SingleKVStore | null = null;

  public async init(context: common.UIAbilityContext) {
    const kvManagerConfig: distributedKVStore.KVManagerConfig = {
      context: context,
      bundleName: 'io.github.thescenery.easyauthenticator'
    };
    try {
      // 创建KVManager实例
      this.kvManager = distributedKVStore.createKVManager(kvManagerConfig);
      console.info('Succeeded in creating KVManager.');
      // 继续创建获取数据库
    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
    }
    await this.initKvStore();
  }

  public static getInstance() {
    if (!DataManager.instance) {
      DataManager.instance = new DataManager();
    }
    return DataManager.instance;
  }

  public async getAll() {
    if (!this.kvStore) {
      throw new Error("kvStore not initalized")
    }
    const entries = await this.kvStore.getEntries(KEY_PREFIX);
    return entries.map((entry) => entry.value.type === distributedKVStore.ValueType.STRING ?
      entry.value.value as string : "")
  }

  public async put(key: string, value: string) {
    if (!this.kvStore) {
      throw new Error("kvStore not initalized");
    }
    return this.kvStore.put(this.formatKey(key), value);
  }

  public async delete(key: string) {
    if (!this.kvStore) {
      throw new Error("kvStore not initalized");
    }
    return this.kvStore.delete(this.formatKey(key));
  }

  private formatKey(key: string) {
    return `${KEY_PREFIX}${key}`;
  }

  private async initKvStore() {
    try {
      if (!this.kvManager) {
        throw new Error("kvManager not initalized")
      }
      const options: distributedKVStore.Options = {
        createIfMissing: true,
        encrypt: true,
        autoSync: false,
        securityLevel: distributedKVStore.SecurityLevel.S4
      };
      this.kvStore = await this.kvManager.getKVStore<distributedKVStore.SingleKVStore>(this.storeId, options);
      console.info("kv store has created");
    } catch (e) {
      let error = e as BusinessError;
      console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  }
}