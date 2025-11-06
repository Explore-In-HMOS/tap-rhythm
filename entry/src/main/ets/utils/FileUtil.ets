import { fileIo as fs } from '@kit.CoreFileKit';

export class FileUtil {
  public static resourcesFile2SandboxFile(rawFilePath: string, sandBoxPath: string) {
    let uint8Array: Uint8Array = getContext().resourceManager.getRawFileContentSync(rawFilePath);
    let file: fs.File = fs.openSync(sandBoxPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, uint8Array.buffer as ArrayBuffer);
    fs.closeSync(file);
  }
}