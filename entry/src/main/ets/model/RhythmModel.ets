interface TapResult {
  diffMs: number;
  accuracy: number;
}

export class RhythmModel {
  private lastTap: number | null = null;
  private targetBpm: number = 120;

  setTargetBpm(bpm: number) {
    this.targetBpm = bpm;
  }

  analyzeTap(): TapResult {
    const now = Date.now();
    const expectedInterval = (60 / this.targetBpm) * 1000; // ms

    if (this.lastTap === null) {
      this.lastTap = now;
      return { diffMs: 0, accuracy: 100 };
    }

    const actualInterval = now - this.lastTap;
    const diff = Math.abs(actualInterval - expectedInterval);

    let accuracy = 100 - (diff / expectedInterval) * 100;
    if (accuracy < 0) accuracy = 0;
    if (accuracy > 100) accuracy = 100;
    accuracy = Math.round(accuracy);

    this.lastTap = now;

    return { diffMs: diff, accuracy };
  }

  reset() {
    this.lastTap = null;
  }
}
