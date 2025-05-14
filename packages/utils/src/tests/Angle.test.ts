import { Angle, Point } from '../geometry';

describe('Angle', () => {
  describe('constructor == asValue', () => {
    it('degrees == asValue', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: 90 });
      expect(angle.asValue).toEqual({ angleUnit: 'degrees', angleValue: 90 });
    });

    it('radians == asValue', () => {
      const angle = new Angle({ angleUnit: 'radians', angleValue: Math.PI });
      expect(angle.asValue).toEqual({ angleUnit: 'radians', angleValue: Math.PI });
    });
  });

  describe('conversion: degrees <-> radians', () => {
    it('should convert degrees to radians', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: 180 });
      expect(angle.radians).toBeCloseTo(Math.PI);
    });

    it('should convert radians to degrees', () => {
      const angle = new Angle({ angleUnit: 'radians', angleValue: Math.PI });
      expect(angle.degrees).toBeCloseTo(180);
    });
  });

  describe('normalized', () => {
    it('should normalize 370 degrees to 10', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: 370 });
      expect(angle.normalized.degrees).toBeCloseTo(10);
    });

    it('should normalize -30 degrees to 330', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: -30 });
      expect(angle.normalized.degrees).toBeCloseTo(330);
    });

    it('should not adjust already normal angles', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: 90 });
      expect(angle.normalized.degrees).toBeCloseTo(90);
    });
  });

  describe('isZero', () => {
    it('should return true if angle value is 0', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: 0 });
      expect(angle.isZero).toBe(true);
    });

    it('should return false if angle value is not 0', () => {
      const angle = new Angle({ angleUnit: 'radians', angleValue: 0.1 });
      expect(angle.isZero).toBe(false);
    });
  });

  describe('getPointAlongCircle', () => {
    const center = new Point({ x: 0, y: 0 });
    const radius = 10;

    it('should compute correct point for 0° (degrees, CCW)', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: 0 });
      const pt = angle.getPointAlongCircle({ radius, centerPoint: center, isClockwise: false });
      expect(pt.x).toBeCloseTo(10);
      expect(pt.y).toBeCloseTo(0);
    });

    it('should compute correct point for 90° (degrees, CCW)', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: 90 });
      const pt = angle.getPointAlongCircle({ radius, centerPoint: center, isClockwise: false });
      expect(pt.x).toBeCloseTo(0);
      expect(pt.y).toBeCloseTo(10);
    });

    it('should compute correct point for 90° (degrees, CW)', () => {
      const angle = new Angle({ angleUnit: 'degrees', angleValue: 90 });
      const pt = angle.getPointAlongCircle({ radius, centerPoint: center, isClockwise: true });
      expect(pt.x).toBeCloseTo(0);
      expect(pt.y).toBeCloseTo(-10);
    });
  });

  describe('computeMidAngle', () => {
    it('should compute midpoint between 0° and 90° CCW', () => {
      const a1 = new Angle({ angleUnit: 'degrees', angleValue: 0 });
      const a2 = new Angle({ angleUnit: 'degrees', angleValue: 90 });
      const mid = a1.computeMidAngle({ otherAngle: a2, isClockwise: false });
      expect(mid.degrees).toBeCloseTo(45);
    });

    it('should compute midpoint between 350° and 10° CCW correctly', () => {
      const a1 = new Angle({ angleUnit: 'degrees', angleValue: 350 });
      const a2 = new Angle({ angleUnit: 'degrees', angleValue: 10 });
      const mid = a1.computeMidAngle({ otherAngle: a2, isClockwise: false });
      expect(mid.degrees).toBeCloseTo(0);
    });

    it('should compute midpoint between 10° and 350° CW correctly', () => {
      const a1 = new Angle({ angleUnit: 'degrees', angleValue: 10 });
      const a2 = new Angle({ angleUnit: 'degrees', angleValue: 350 });
      const mid = a1.computeMidAngle({ otherAngle: a2, isClockwise: true });
      expect(mid.degrees).toBeCloseTo(0);
    });
  });
});
