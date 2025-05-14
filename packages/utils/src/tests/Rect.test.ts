import { Rect, Point, SizeValue, PointValue } from '../geometry';

describe('Rect', () => {
  describe('constructor', () => {
    it('should construct from origin and size', () => {
      const rect = new Rect({
        mode: 'originAndSize',
        origin: { x: 10, y: 20 },
        size: { width: 100, height: 50 },
      });

      expect(rect.origin.x).toBe(10);
      expect(rect.origin.y).toBe(20);
      expect(rect.width).toBe(100);
      expect(rect.height).toBe(50);
    });

    it('should construct from corners', () => {
      const rect = new Rect({
        mode: 'corners',
        minX: 10,
        minY: 20,
        maxX: 110,
        maxY: 70,
      });

      expect(rect.origin.x).toBe(10);
      expect(rect.origin.y).toBe(20);
      expect(rect.width).toBe(100);
      expect(rect.height).toBe(50);
    });
  });

  describe('computed properties', () => {
    const rect = new Rect({
      mode: 'originAndSize',
      origin: { x: 10, y: 20 },
      size: { width: 100, height: 60 },
    });

    it('should return correct corner values', () => {
      expect(rect.cornerPoints).toEqual({
        minX: 10,
        minY: 20,
        maxX: 110,
        maxY: 80,
      });
    });

    it('should compute center point correctly', () => {
      const center = rect.centerPoint;
      expect(center.x).toBe(60); // 10 + 100/2
      expect(center.y).toBe(50); // 20 + 60/2
    });

    it('should compute midpoints', () => {
      expect(rect.topMidPoint).toEqual(new Point({ x: 60, y: 20 }));
      expect(rect.bottomMidPoint).toEqual(new Point({ x: 60, y: 80 }));
      expect(rect.leftMidPoint).toEqual(new Point({ x: 10, y: 50 }));
      expect(rect.rightMidPoint).toEqual(new Point({ x: 110, y: 50 }));
    });

    it('should compute corners correctly', () => {
      expect(rect.topLeftPoint).toEqual(new Point({ x: 10, y: 20 }));
      expect(rect.topRightPoint).toEqual(new Point({ x: 110, y: 20 }));
      expect(rect.bottomLeftPoint).toEqual(new Point({ x: 10, y: 80 }));
      expect(rect.bottomRightPoint).toEqual(new Point({ x: 110, y: 80 }));
    });
  });

  describe('isNaN', () => {
    it('should detect NaN in origin', () => {
      const rect = new Rect({
        mode: 'originAndSize',
        origin: { x: NaN, y: 20 },
        size: { width: 100, height: 50 },
      });

      expect(rect.isNaN).toBe(true);
    });

    it('should detect NaN in size', () => {
      const rect = new Rect({
        mode: 'originAndSize',
        origin: { x: 10, y: 20 },
        size: { width: NaN, height: 50 },
      });

      expect(rect.isNaN).toBe(true);
    });

    it('should not be NaN if all values are valid', () => {
      const rect = new Rect({
        mode: 'originAndSize',
        origin: { x: 10, y: 20 },
        size: { width: 100, height: 50 },
      });

      expect(rect.isNaN).toBe(false);
    });
  });

  describe('adjust points', () => {
    let rect: Rect;

    const rectOrigin: PointValue = { x: 10, y: 20 };
    const rectSize: SizeValue = { width: 100, height: 50 };

    beforeEach(() => {
      rect = new Rect({
        mode: 'originAndSize',
        origin: rectOrigin,
        size: rectSize,
      });
    });

    it('should adjust top left corner', () => {
      rect.minX = 0;
      rect.minY = 0;

      expect(rect.minX).toBe(0);
      expect(rect.minY).toBe(0);
      expect(rect.maxX).toBe(rectSize.width);
      expect(rect.maxY).toBe(rectSize.height);
    });

    it('should adjust center corner', () => {
      rect.midX = 100;
      rect.midY = 100;

      expect(rect.centerPoint.x).toBe(100);
      expect(rect.centerPoint.y).toBe(100);
      expect(rect.width).toBe(rectSize.width);
      expect(rect.height).toBe(rectSize.height);
    });

    it('should adjust bottom right corner', () => {
      rect.maxX = 150;
      rect.maxY = 90;
      
      expect(rect.maxX).toBe(150);
      expect(rect.maxY).toBe(90);
      expect(rect.width).toBe(rectSize.width);
      expect(rect.height).toBe(rectSize.height);
    });

    it('should adjust top right corner', () => {
      rect.maxX = 200;
      rect.minY = 100;

      expect(rect.maxX).toBe(200);
      expect(rect.minY).toBe(100);
      expect(rect.width).toBe(rectSize.width);
      expect(rect.height).toBe(rectSize.height);
    });

    it('should adjust bottom left corner', () => {
      rect.minX = 0;
      rect.maxY = 200;

      expect(rect.minX).toBe(0);
      expect(rect.maxY).toBe(200);
      expect(rect.width).toBe(rectSize.width);
      expect(rect.height).toBe(rectSize.height);
    });
  });

  describe('setPointCenter', () => {
    it('should move origin to center new point', () => {
      const rect = new Rect({
        mode: 'originAndSize',
        origin: { x: 0, y: 0 },
        size: { width: 100, height: 50 },
      });

      rect.setPointCenter(new Point({ x: 50, y: 50 }));

      expect(rect.origin.x).toBe(0); // 50 - 100/2
      expect(rect.origin.y).toBe(25); // 50 - 50/2
    });
  });

  describe('applyScaleToNewSize', () => {
    it('should apply scale and keep center fixed', () => {
      const rect = new Rect({
        mode: 'originAndSize',
        origin: { x: 0, y: 0 },
        size: { width: 100, height: 50 },
      });

      rect.applyScaleToNewSize({ width: 200, height: 100 });

      expect(rect.width).toBe(200);
      expect(rect.height).toBe(100);
      expect(rect.centerPoint).toEqual(new Point({ x: 50, y: 25 }));
    });
  });

  describe('applyScaleByFactor', () => {
    it('should scale width and height by factors', () => {
      const rect = new Rect({
        mode: 'originAndSize',
        origin: { x: 0, y: 0 },
        size: { width: 100, height: 50 },
      });

      rect.applyScaleByFactor(2, 3);

      expect(rect.width).toBe(200);
      expect(rect.height).toBe(150);
      expect(rect.centerPoint).toEqual(new Point({ x: 50, y: 25 }));
    });
  });
});
