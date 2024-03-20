import { View, Text, Image, TouchableOpacity } from "react-native";

import { ContextMenuViewProps } from "react-native-ios-context-menu";
import * as Colors from '../../constants/Colors';


const EmojiPleadingFaceImage = Image.resolveAssetSource(
  require('../../../assets/emoji-pleading-face.png')
);

const EmojiSmilingFaceImage = Image.resolveAssetSource(
  require('../../../assets/emoji-smiling-face-with-hearts.png')
);

const EmojiSparklingHeartImage = Image.resolveAssetSource(
  require('../../../assets/emoji-sparkling-heart.png')
);

type ContextMenuConfigPresetItem = {
  menuConfig?: ContextMenuViewProps['menuConfig'];
  previewConfig?: ContextMenuViewProps['previewConfig'];
  onRequestDeferredElement?: ContextMenuViewProps['onRequestDeferredElement'];
  renderPreview?: ContextMenuViewProps['renderPreview'];
};

export const ContextMenuConfigExamplePreset01: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'BasicUsageExample01',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
    }, {
      actionKey  : 'key-02'   ,
      actionTitle: 'Action #2',
    }, {
      actionKey  : 'key-03'   ,
      actionTitle: 'Action #3',
    }],
  },
};

export const ContextMenuConfigExamplePreset02: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample02',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'folder',
        },
      }
    }, {
      actionKey  : 'key-02'   ,
      actionTitle: 'Action #2',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'dial.fill',
        },
      }
    }, {
      actionKey  : 'key-03'   ,
      actionTitle: 'Action #3',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'archivebox.fill',
        },
      }
    }],
  },
};

export const ContextMenuConfigExamplePreset03: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample03',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'folder',
        },
      }
    }, {
      menuTitle: 'Submenu...',
      menuItems: [{
        actionKey  : 'key-01-01',
        actionTitle: 'Submenu Action #1',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star',
          },
        }
      }, {
        actionKey  : 'key-01-02',
        actionTitle: 'Submenu Action #2',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.lefthalf.fill',
          },
        }
      }, {
        actionKey  : 'key-01-03',
        actionTitle: 'Submenu Action #3',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.fill',
          },
        }
      }]
    }],
  },
};

export const ContextMenuConfigExamplePreset04: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample04',
    menuItems: [{
      actionKey     : 'key-01',
      actionTitle   : 'Disabled Action',
      menuAttributes: ['disabled'],
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'folder',
        },
      }
    }, {
      actionKey     : 'key-02'   ,
      actionTitle   : 'Destructive Action',
      menuAttributes: ['destructive'],
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'trash',
        },
      }
    }, {
      actionKey     : 'key-03'   ,
      actionTitle   : 'Hidden Action',
      menuAttributes: ['hidden'],
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'trash',
        },
      }
    }, {
      actionKey     : 'key-04'   ,
      actionTitle   : 'Disabled/Destructive',
      menuAttributes: ['disabled', 'destructive'],
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'trash.fill',
        },
      }
    }],
  },
};

export const ContextMenuConfigExamplePreset05: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample05',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'folder',
        },
      }
    }, {
      menuTitle: 'Submenu...',
      // Create "Inline submenu" by adding `displayInline`
      // in the menu options...
      menuOptions: ['displayInline'],
      menuItems: [{
        actionKey  : 'key-01-01',
        actionTitle: 'Submenu Action #1',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star',
          },
        }
      }, {
        actionKey  : 'key-01-02',
        actionTitle: 'Submenu Action #2',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.lefthalf.fill',
          },
        }
      }, {
        actionKey  : 'key-01-03',
        actionTitle: 'Submenu Action #3',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.fill',
          },
        }
      }]
    }],
  },
};

export const ContextMenuConfigExamplePreset06: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample06',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'folder',
        },
      }
    }, {
      menuTitle: 'Submenu...',
      // Create an "destructive" submenu by adding
      // `destructive` in the menu options...
      menuOptions: ['destructive'],
      menuItems: [{
        actionKey  : 'key-01-01',
        actionTitle: 'Submenu Action #1',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star',
          },
        }
      }, {
        actionKey  : 'key-01-02',
        actionTitle: 'Submenu Action #2',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.lefthalf.fill',
          },
        }
      }, {
        actionKey  : 'key-01-03',
        actionTitle: 'Submenu Action #3',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.fill',
          },
        }
      }]
    }],
  },
};

export const ContextMenuConfigExamplePreset07: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample07',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'folder',
        },
      }
    }, {
      menuTitle: 'Submenu...',
      // Make the submenu both `'displayInline'` and
      // `'destructive'`.
      //
      // Visually, this is just the same as passing in 
      // 'displayInline'.
      menuOptions: ['displayInline', 'destructive'],
      menuItems: [{
        actionKey  : 'key-01-01',
        actionTitle: 'Submenu Action #1',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star',
          },
        }
      }, {
        actionKey  : 'key-01-02',
        actionTitle: 'Submenu Action #2',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.lefthalf.fill',
          },
        }
      }, {
        actionKey  : 'key-01-03',
        actionTitle: 'Submenu Action #3',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.fill',
          },
        }
      }]
    }],
  },
};

export const ContextMenuConfigExamplePreset08: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample08',
    menuItems: [{
    actionKey  : 'key-01',
    actionTitle: 'menuState: on',
    // show a checkmark
    menuState: 'on',
    icon: {
      type: 'IMAGE_SYSTEM',
      imageValue: {
        systemName: 'folder',
      },
    }
  }, {
    actionKey  : 'key-02'   ,
    actionTitle: 'menuState: off',
    // no checkmark
    menuState: 'off',
    icon: {
      type: 'IMAGE_SYSTEM',
      imageValue: {
        systemName: 'dial',
      },
    }
  }, {
    actionKey  : 'key-03'   ,
    actionTitle: 'menuState: mixed',
    menuState  : 'mixed',
    icon: {
      type: 'IMAGE_SYSTEM',
      imageValue: {
        systemName: 'archivebox',
      },
    }
    }],
  },
};

export const ContextMenuConfigExamplePreset09: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample09',
    menuItems: [{
      actionKey  : 'save',
      actionTitle: 'Save',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'square.and.arrow.down',
        },
      }
    }, {
      actionKey  : 'like',
      actionTitle: 'Like',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'hand.thumbsup',
        },
      }
    }, {
      actionKey  : 'play',
      actionTitle: 'Play',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'play',
        },
      }
    }],
  },
};

export const ContextMenuConfigExamplePreset11: ContextMenuConfigPresetItem = {
  previewConfig: {
    previewType: 'CUSTOM',
    previewSize: 'STRETCH',
    backgroundColor: 'white'
  },
  renderPreview: () => (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text style={{fontSize: 32}}>
        Hello World
      </Text>
      <Text style={{fontSize: 32}}>
        Hello World
      </Text>
      <Text style={{fontSize: 32}}>
        Hello World
      </Text>
    </View>
  ),
};

export const ContextMenuConfigExamplePreset13: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample13',
    menuItems: [{
      actionKey: 'key-01',
      actionTitle: 'Action #1',
      // old way of adding a subtitle...
      // iOS 13 to 14 (still works on iOS 15+)
      discoverabilityTitle: 'Action subtitle',
    }, {
      actionKey: 'key-02'   ,
      actionTitle: 'Action #2',
      // new way of adding a subtitle...
      // iOS 15+ only, but is automatically backwards compatible w/
      // iOS 13/14...
      actionSubtitle: 'Lorum ipsum sit amit dolor aspicing',
    }, {
      actionKey: 'key-03'   ,
      actionTitle: 'Action #3',
      actionSubtitle: 'Very long `discoverabilityTitle` lorum ipsum sit amit',
    }],
  },
};

export const ContextMenuConfigExamplePreset14: ContextMenuConfigPresetItem = {
  previewConfig: {
    previewType: 'CUSTOM',
    previewSize: 'STRETCH',
    backgroundColor: 'rgba(255,255,255,0.75)',
    // change the exit transition that occurs when the 
    // context menu preview is pressed.
    preferredCommitStyle: 'pop',
  },
  renderPreview: () => (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <TouchableOpacity>
        <Text style={{fontSize: 32}}>
          Hello World
        </Text>
      </TouchableOpacity>
      <TouchableOpacity>
        <Text style={{fontSize: 32}}>
          Hello World
        </Text>
      </TouchableOpacity>
      <TouchableOpacity>
        <Text style={{fontSize: 32}}>
          Hello World
        </Text>
      </TouchableOpacity>
    </View>
  ),
};

export const ContextMenuConfigExamplePreset16: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample16',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
      discoverabilityTitle: 'No Icon',
    }, {
      actionKey  : 'key-02'   ,
      actionTitle: 'Action #2',
      discoverabilityTitle: 'Use "IMAGE_SYSTEM" icon',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'dial.fill',
        },
      }
    }, {
      actionKey  : 'key-03'   ,
      actionTitle: 'Action #3',
      discoverabilityTitle: 'Use "ASSET" icon',
      icon: {
        // specify that you want to use an asset icon
        type: 'IMAGE_ASSET',
        // pass the name of the asset
        imageValue: 'icon-rainbow-flag',
      }
    }],
  },
};

export const ContextMenuConfigExamplePreset17: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample17',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
      discoverabilityTitle: 'Blue Icon',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'cloud.heavyrain.fill',
        },
        // blue icon
        imageOptions: {
          tint: 'blue',
          renderingMode: 'alwaysOriginal',
        },
      },
    }, {
      actionKey  : 'key-02',
      actionTitle: 'Action #2',
      discoverabilityTitle: 'Orange Icon',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'exclamationmark.triangle.fill',
        },
        // orange icon
        imageOptions: {
          tint: 'rgb(218,165,32)',
          renderingMode: 'alwaysOriginal',
        },
      },
    }, {
      actionKey  : 'key-03',
      actionTitle: 'Action #3',
      discoverabilityTitle: 'Pink Icon',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'heart.fill',
        },
        // pink icon
        imageOptions: {
          tint: '#FF1493',
          renderingMode: 'alwaysOriginal',
        },
      },
    }, {
      actionKey  : 'key-04',
      actionTitle: 'Action #4',
      discoverabilityTitle: 'Green Icon',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'bubble.right.fill',
        },
        // green icon
        imageOptions: {
          tint: 'rgba(124,252,0,0.5)',
          renderingMode: 'alwaysOriginal',
        },
      },
    }]
  },
};

export const ContextMenuConfigExamplePreset18: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample18',
    menuItems: [{
      actionKey  : 'key-01'   ,
      actionTitle: 'Action #1',
      discoverabilityTitle: 'Use "REQUIRE" icon',
      // `IconConfig` has been deprecated, please use 
      // `ImageItemConfig` instead (but it'll still work for now).
      // 
      // The other two menu actions in this example 
      // uses `ImageItemConfig` to set the menu action icons. 
      icon: {
        iconType: 'REQUIRE',
        iconValue: EmojiPleadingFaceImage,
      }
    }, {
      actionKey  : 'key-02'   ,
      actionTitle: 'Action #2',
      discoverabilityTitle: 'Use "IMAGE_REQUIRE" icon',
      icon: {
        // Set config to use images via `require`
        type: 'IMAGE_REQUIRE',
        // Pass in the corresponding
        // `ImageResolvedAssetSource` object of the image
        // that you want to use as the icon...
        imageValue: EmojiSmilingFaceImage,
      }
    }, {
      actionKey  : 'key-03'   ,
      actionTitle: 'Action #3',
      discoverabilityTitle: 'Use "IMAGE_REQUIRE" icon',
      icon: {
        type: 'IMAGE_REQUIRE',
        imageValue: EmojiSparklingHeartImage,
      }
    }],
  },
};

export const ContextMenuConfigExamplePreset19: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample19',
    menuItems: [{
      actionKey  : 'key-01',
      actionTitle: 'Action #1',
      actionSubtitle: 'Dummy action'
    }, {
      // Create a deferred menu item... this will act as a placeholder
      // and will be replaced with the actual menu items later
      type: 'deferred',
      // if we have multiple deferred items, you can use the `deferredID`
      // to distinguish between them
      deferredID: 'deferred-01'
    }],
  },
};

export const ContextMenuConfigExamplePreset21: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample21',
    menuPreferredElementSize: 'medium',
    menuItems: [{
      actionKey: 'key-01',
      actionTitle: 'Action #1',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'folder',
        },
      }
    }, {
      actionKey: 'key-02'   ,
      actionTitle: 'Action #2',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'dial.fill',
        },
      }
    }, {
      actionKey  : 'key-03'   ,
      actionTitle: 'Action #3',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'archivebox.fill',
        },
      }
    }],
  },
};

export const ContextMenuConfigExamplePreset22: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: '',
    menuPreferredElementSize: 'small',
    menuItems: [{
      actionKey: 'key-01',
      actionTitle: '',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'star',
          weight: 'heavy',
          scale: 'large',
        },
        imageOptions: {
          renderingMode: 'alwaysOriginal',
          tint: Colors.AMBER.A700,
        }
      }
    }, {
      actionKey: 'key-02'   ,
      actionTitle: '',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'star.lefthalf.fill',
          weight: 'heavy',
          scale: 'large',
        },
        imageOptions: {
          renderingMode: 'alwaysOriginal',
          tint: Colors.AMBER.A700,
        }
      }
    }, {
      actionKey: 'key-03',
      actionTitle: '',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'star.fill',
          weight: 'heavy',
          scale: 'large',
        },
        imageOptions: {
          renderingMode: 'alwaysOriginal',
          tint: Colors.AMBER.A700,
        }
      }
    }],
  },
};

export const ContextMenuConfigExamplePreset23: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: '',
    menuItems: [{
      type: 'action',
      actionKey: 'remove-rating',
      menuAttributes: ['destructive'],
      actionTitle: 'Remove Rating',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'trash',
        },
      },
    }, {
      type: 'action',
      actionKey: 'info',
      actionTitle: 'Information',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'info.circle',
        },
      },
    }, {
      type: 'menu',
      menuTitle: '',
      menuOptions: ['displayInline'],
      menuPreferredElementSize: 'small',
      menuItems: [{
      actionKey: 'key-01-01',
      actionTitle: '',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'hand.thumbsup',
          },
          imageOptions: {
            renderingMode: 'alwaysOriginal',
            tint: Colors.GREEN.A700,
          }
        }
      }, {
        actionKey: 'key-01-02',
        actionTitle: '',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'plus.circle',
          },
          imageOptions: {
            renderingMode: 'alwaysOriginal',
            tint: Colors.BLUE.A700,
          }
        }
      }, {
        actionKey: 'key-01-03',
        actionTitle: '',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'hand.thumbsdown',
          },
          imageOptions: {
            renderingMode: 'alwaysOriginal',
            tint: Colors.RED.A700,
          }
        }
      }],
    }, {
      type: 'menu',
      menuTitle: '',
      menuOptions: ['displayInline'],
      menuPreferredElementSize: 'small',
      menuItems: [{
      actionKey: 'key-02-01',
      actionTitle: '',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star',
          },
          imageOptions: {
            renderingMode: 'alwaysOriginal',
            tint: Colors.AMBER.A700,
          }
        }
      }, {
        actionKey: 'key-02-02'   ,
        actionTitle: '',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.lefthalf.fill',
          },
          imageOptions: {
            renderingMode: 'alwaysOriginal',
            tint: Colors.AMBER.A700,
          }
        }
      }, {
        actionKey: 'key-02-03',
        actionTitle: '',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'star.fill',
          },
          imageOptions: {
            renderingMode: 'alwaysOriginal',
            tint: Colors.AMBER.A700,
          }
        }
      }],
    }]
  },
};

export const ContextMenuConfigExamplePreset25: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample25',
    menuItems: [{
      type: 'menu',
      menuTitle: '',
      menuOptions: ['displayInline'],
      menuItems: [{
        actionKey: 'key-01-01',
        actionTitle: 'small',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'heart',
            scale: 'small',
          },
        }
      }, {
        actionKey: 'key-01-02',
        actionTitle: 'medium',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'heart',
            scale: 'medium',
          },
        }
      }, {
        actionKey: 'key-01-03',
        actionTitle: 'large',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'heart',
            scale: 'large',
          },
        }
      }],
    }, {
      type: 'menu',
      menuTitle: '',
      menuOptions: ['displayInline'],
      menuItems: [{
        actionKey: 'key-02-01',
        actionTitle: 'ultraLight',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'heart',
            weight: 'ultraLight',
          },
        }
      }, {
        actionKey: 'key-02-02',
        actionTitle: 'semibold',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'heart',
            weight: 'semibold',
          },
        }
      }, {
        actionKey: 'key-02-03',
        actionTitle: 'black',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'heart',
            weight: 'black',
          },
        }
      }],
    },  {
      type: 'menu',
      menuTitle: '',
      menuOptions: ['displayInline'],
      menuItems: [{
        actionKey: 'key-03-01',
        actionTitle: 'paletteColors',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'delete.left.fill',
            paletteColors: ['red', 'blue']
          },
        }
      }, {
        actionKey: 'key-03-02',
        actionTitle: 'semibold',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'delete.left.fill',
            hierarchicalColor: 'red',
          },
        }
      }, {
        actionKey: 'key-03-03',
        actionTitle: 'paletteColors',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'folder.fill.badge.plus',
            paletteColors: ['blue', 'red']
          },
        }
      },  {
        actionKey: 'key-03-04',
        actionTitle: 'hierarchicalColor',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'folder.fill.badge.plus',
            hierarchicalColor: 'blue',
          },
        }
      }],
    }],
  },
};

export const ContextMenuConfigExamplePreset26: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample26',
    menuItems: [{
      actionKey  : 'key-01'   ,
      actionTitle: 'Action #1',
      actionSubtitle: 'Use "IMAGE_REMOTE_URL" icon',
      icon: {
        type: 'IMAGE_REMOTE_URL',
        imageValue: {
          url: 'https://picsum.photos/id/1/100'
        },
      }
    }, {
      actionKey  : 'key-02'   ,
      actionTitle: 'Action #2',
      actionSubtitle: '"IMAGE_REMOTE_URL" + shouldLazyLoad',
      icon: {
        type: 'IMAGE_REMOTE_URL',
        imageValue: {
          url: 'https://picsum.photos/id/2/100'
        },
        imageLoadingConfig: {
          shouldLazyLoad: true,
        },
        imageOptions: {
          cornerRadius: 15,
        },
      }
    }, {
      actionKey  : 'key-03'   ,
      actionTitle: 'Action #3',
      actionSubtitle: '"IMAGE_REMOTE_URL" + shouldLazyLoad + shouldCache',
      icon: {
        type: 'IMAGE_REMOTE_URL',
        imageValue: {
          url: 'https://picsum.photos/id/2/100'
        },
        imageLoadingConfig: {
          shouldLazyLoad: true,
          shouldCache: true,
        },
        imageOptions: {
          cornerRadius: 30,
          tint: 'rgba(255,0,0,0.5)',
          renderingMode: 'alwaysOriginal',
        },
      }
    },  {
      actionKey  : 'key-04'   ,
      actionTitle: 'Action #4',
      actionSubtitle: '"IMAGE_REMOTE_URL" + shouldLazyLoad + shouldCache',
      icon: {
        type: 'IMAGE_REMOTE_URL',
        imageValue: {
          url: 'https://picsum.photos/x',
          fallbackImage: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'heart'
            },
          },
        },
        imageLoadingConfig: {
          shouldLazyLoad: true,
          fallbackBehavior: 'afterFinalAttempt',
          shouldImmediatelyRetryLoading: true,
        },
      }
    }],
  },
};

export const ContextMenuConfigExamplePreset27: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewExample27',
    menuItems: [{
      actionKey  : 'key-01'   ,
      actionTitle: 'Action #1',
      actionSubtitle: 'fallbackBehavior: whileNotLoaded',
      icon: {
        type: 'IMAGE_REMOTE_URL',
        imageValue: {
          url: 'https://fake.url.com/asset-1',
          fallbackImage: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'trash',
            },
          },
        },
        imageLoadingConfig: {
          // will use the fallback image while the remote
          // image hasn't been loaded yet
          fallbackBehavior: 'whileNotLoaded',
          shouldLazyLoad: true,
          shouldImmediatelyRetryLoading: true,
          maxRetryAttempts: 20,
        },
      }, 
    }, {
      actionKey  : 'key-02'   ,
      actionTitle: 'Action #2',
      actionSubtitle: 'fallbackBehavior: onLoadError',
      icon: {
        type: 'IMAGE_REMOTE_URL',
        imageValue: {
          url: 'https://fake.url.com/asset-2',
          fallbackImage: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'trash',
            },
          },
        },
        imageLoadingConfig: {
          // will use the fallback image when it encounters
          // an error whe loading the remote image
          fallbackBehavior: 'onLoadError',
          shouldLazyLoad: true,
          shouldImmediatelyRetryLoading: true,
          maxRetryAttempts: 20,
        },
      }
    },  {
      actionKey  : 'key-03'   ,
      actionTitle: 'Action #3',
      actionSubtitle: 'fallbackBehavior: afterFinalAttempt',
      icon: {
        type: 'IMAGE_REMOTE_URL',
        imageValue: {
          url: 'https://fake.url.com/asset-3',
          fallbackImage: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'trash',
            },
          },
        },
        imageLoadingConfig: {
          // will use the fallback image when it encounters
          // an error whe loading the remote image, and the
          // number of loading attempts exceeds 
          // `maxRetryAttempts` 
          fallbackBehavior: 'afterFinalAttempt',
          shouldLazyLoad: true,
          shouldImmediatelyRetryLoading: true,
          maxRetryAttempts: 20,
        },
      }
    }],
  },
};

export const ContextMenuConfigTestPreset01: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewTest01',
    menuItems: [{
      actionKey  : 'key-01'   ,
      actionTitle: 'Action #1',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'hare',
        },
      }
    }, {
      actionKey  : 'key-02'   ,
      actionTitle: 'Action #2',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'calendar',
        },
      }
    }, {
      menuTitle: 'Submenu #1...',
      menuSubtitle: 'Nested Menu',
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'ant',
        },
      },
      menuItems: [{
        actionKey  : 'key-03-01'   ,
        actionTitle: 'Submenu Action #3',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'moon',
          },
        },
      }, {
        actionKey  : 'key-03-02'   ,
        actionTitle: 'Submenu Action #4',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'house',
          },
        }
      }, {
        menuTitle: 'Submenu #5...',
        menuSubtitle: 'Nested Menu',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'moon.stars',
          },
        },
        menuItems: [{
          actionKey  : 'key-03-03-01',
          actionTitle: 'Submenu Action #5',
          icon: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'dial',
            },
          }
        }, {
          actionKey  : 'key-03-03-02',
          actionTitle: 'Submenu Action #6',
          icon: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'square.and.arrow.up.on.square',
            },
          }
        }, {
          menuTitle: 'Submenu #3...',
          menuSubtitle: 'Nested Menu',
          icon: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'archivebox',
            },
          },
          menuItems: [{
            actionKey  : 'key-03-03-03-01',
            actionTitle: 'Submenu Action #7',
            icon: {
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'folder',
              },
            },
          }, {
            actionKey  : 'key-03-03-03-02',
            actionTitle: 'Submenu Action #8',
            icon: {
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'pencil.slash',
              },
            }
          }, {
            menuTitle: 'Submenu #4...',
            menuSubtitle: 'Nested Menu',
            icon: {
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'rosette',
              },
            },
            menuItems: [{
              actionKey  : 'key-03-03-03-03-01',
              actionTitle: 'Submenu Action #9',
              icon: {
                type: 'IMAGE_SYSTEM',
                imageValue: {
                  systemName: 'lessthan.circle',
                },
              }
            }, {
              actionKey  : 'key-03-03-03-03-02',
              actionTitle: 'Submenu Action #10',
              icon: {
                type: 'IMAGE_SYSTEM',
                imageValue: {
                  systemName: 'divide.square',
                },
              }
            }, {
              actionKey  : 'key-03-03-03-03-03',
              actionTitle: 'Submenu Action #11',
              icon: {
                type: 'IMAGE_SYSTEM',
                imageValue: {
                  systemName: 'cloud.moon',
                },
              }
            }],
          }],
        }],
      }],
    }],
  },
};

export const ContextMenuConfigTestPreset02: ContextMenuConfigPresetItem = {
  menuConfig: {
    menuTitle: 'ContextMenuViewTest02',
    menuItems: [{
      menuTitle: 'Inline Submenu #1',
      menuOptions: ['displayInline'],
      menuItems: [{
        actionKey  : 'key-01'   ,
        actionTitle: 'Inline Action #1',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'hare',
          },
        }
      }, {
        menuTitle  : 'Submenu #1...',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'calendar',
          },
        },
        menuItems: [{
          actionKey  : 'key-02-01',
          actionTitle: 'Submenu Action #1',
          icon: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'paperclip',
            },
          }
        }, {
          menuTitle: 'Inline Submenu #4',
          menuOptions: ['displayInline'],
          menuItems: [{
            actionKey  : 'key-02-02',
            actionTitle: 'Inline Submenu Action #2',
            icon: {
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'house',
              },
            }
          }, {
            actionKey  : 'key-02-03',
            actionTitle: 'Inline Submenu Action #3',
            icon: {
              type: 'IMAGE_SYSTEM',
              imageValue: {
                systemName: 'tag',
              },
            }
          }],
        }, {
          actionKey  : 'key-02-04',
          actionTitle: 'Submenu Action #4',
          icon: {
            type: 'IMAGE_SYSTEM',
            imageValue: {
              systemName: 'sun.haze',
            },
          }
        }],
      }],
    }, {
      menuTitle: 'Inline Submenu #2',
      menuOptions: ['displayInline'],
      menuItems: [{
        actionKey     : 'key-03'   ,
        actionTitle   : 'Inline Submenu Action #2',
        menuAttributes: ['disabled'],
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'suit.heart',
          },
        }
      }, {
        actionKey  : 'key-04'   ,
        actionTitle: 'Inline Submenu Action #3',
        icon: {
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: 'suit.club',
          },
        }
      }],
    }, {
      actionKey     : 'key-05'   ,
      actionTitle   : 'Action #4',
      menuAttributes: ['destructive'],
      icon: {
        type: 'IMAGE_SYSTEM',
        imageValue: {
          systemName: 'trash',
        },
      }
    }]
  },
};

export const ContextMenuConfigPresets: Array<ContextMenuConfigPresetItem> = [
  ContextMenuConfigExamplePreset01,
  ContextMenuConfigExamplePreset02,
  ContextMenuConfigExamplePreset03,
  ContextMenuConfigExamplePreset04,
  ContextMenuConfigExamplePreset05,
  ContextMenuConfigExamplePreset06,
  ContextMenuConfigExamplePreset07,
  ContextMenuConfigExamplePreset08,
  ContextMenuConfigExamplePreset09,
  ContextMenuConfigExamplePreset11,
  ContextMenuConfigExamplePreset13,
  ContextMenuConfigExamplePreset14,
  ContextMenuConfigExamplePreset16,
  ContextMenuConfigExamplePreset17,
  ContextMenuConfigExamplePreset18,
  ContextMenuConfigExamplePreset19,
  ContextMenuConfigExamplePreset21,
  ContextMenuConfigExamplePreset22,
  ContextMenuConfigExamplePreset23,
  ContextMenuConfigExamplePreset25,
  ContextMenuConfigExamplePreset26,
  ContextMenuConfigExamplePreset27,
  ContextMenuConfigTestPreset01,
  ContextMenuConfigTestPreset02,
];