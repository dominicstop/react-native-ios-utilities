// UIKit - UIOrientation.h

export type UIDeviceOrientation =
    | 'unknown'

    /** Device oriented vertically, home button on the bottom */
    | 'portrait'

    /** Device oriented vertically, home button on the top */
    | 'portraitUpsideDown'

    /** Device oriented horizontally, home button on the right */
    | 'landscapeLeft'

    /** Device oriented horizontally, home button on the left */
    | 'landscapeRight'

    /** Device oriented flat, face up */
    | 'faceUp'

    /** Device oriented flat, face down */
    | 'faceDown';