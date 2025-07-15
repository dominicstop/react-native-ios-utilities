const path = require('path');
const rootDir = path.resolve(__dirname, '../..');

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
          
          'react': path.resolve(__dirname, 'node_modules/react'),
          'react-native': path.resolve(__dirname, 'node_modules/react-native'),
          'react/jsx-runtime': path.resolve(__dirname, 'node_modules/react/jsx-runtime'),
          'react-dom': path.resolve(__dirname, 'node_modules/react-dom'),
        },
      },
    ],
  ],
};
