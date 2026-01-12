import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class FileUtil {
  public static resourcesFile2SandboxFile(rawFilePath: string, sandBoxPath: string, context: Context) {
    try {
      let uint8Array: Uint8Array = context.resourceManager.getRawFileContentSync(rawFilePath);
      let file: fs.File = fs.openSync(sandBoxPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

      try {
        fs.writeSync(file.fd, uint8Array.buffer);
      } catch (writeErr) {
        let err: BusinessError = writeErr as BusinessError;

      } finally {

        fs.closeSync(file);
      }

    } catch (globalErr) {
      let err: BusinessError = globalErr as BusinessError;

    }
  }
}