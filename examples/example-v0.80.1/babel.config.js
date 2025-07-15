const path = require('path');
const rootLibraryPackage = require('../../package.json');
const exampleCorePackage = require('../example-core/package.json');

module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: [
    [
      'module-resolver',
      {
        extensions: ['.tsx', '.ts', '.js', '.json'],
        alias: {
          [rootLibraryPackage.name]: path.join(__dirname, '../..', rootLibraryPackage.source),
          [exampleCorePackage.name]: path.join(__dirname, '..', 'example-core', 'src'),
        },
      },
    ],
  ],
};
