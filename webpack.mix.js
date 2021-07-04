const cssImport = require('postcss-import')
const cssNesting = require('postcss-nesting')
const mix = require('laravel-mix')
const path = require('path')
const vapormix = require('./vapor.mix')

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

const cwd = (dir) => path.resolve(__dirname, dir);

mix.setPublicPath('Public')
  .setResourceRoot(cwd('Resources'))
  .js('Resources/js/app.js', 'js')
  .postCss('Resources/css/app.css', 'css')
  .options({
    postCss: [
      cssImport(),
      cssNesting(),
    ],
  })
  .webpackConfig({
    output: { chunkFilename: 'js/[name].js?id=[chunkhash]' },
    resolve: {
      extensions: ['.js', '.svelte'],
      mainFields: ['svelte', 'browser', 'module', 'main'],
      alias: {
        '@': path.resolve('Resources/js'),
      },
    },
    module: {
      rules: [
        {
          test: /\.(svelte)$/,
          use: {
            loader: 'svelte-loader',
            options: {
              emitCss: true,
              hotReload: true,
            },
          },
        },
      ],
    },
  })
  .version()
  .sourceMaps()
  .then(() => {
    return vapormix()
  });
