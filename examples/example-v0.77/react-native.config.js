const path = require('path');

const libraryPackage = require('../../package.json');
const exampleCorePackage = require('../example-core/package.json');

module.exports = {
  project: {
    ios: {
      automaticPodsInstallation: true,
    },
  },
  dependencies: {
    [libraryPackage.name]: {
      root: path.join(__dirname, '../..'),
      platforms: {
        // Codegen script incorrectly fails without this
        // So we explicitly specify the platforms with empty object
        ios: {},
        android: {},
      },
    },
    [exampleCorePackage.name]: {
      root: path.join(__dirname, '../example-core'),
      platforms: {
        // Codegen script incorrectly fails without this
        // So we explicitly specify the platforms with empty object
        ios: {},
        android: {},
      },
    },
  },
};
