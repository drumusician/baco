defmodule Mix.Tasks.Convert.PhxRootConfig do
  @moduledoc """
  Put asset config files in root directory
  """
  use Mix.Task

  @shortdoc "Put asset config files in root directory"

  def run(_argv) do
    move_js_configs()
  end

  defp move_js_configs do
    File.rename("./assets/package.json", "./package.json")
    File.rename("./assets/webpack.config.js", "./webpack.config.js")
    File.rename("./assets/.babelrc", "./.babelrc")

    Mix.Generator.create_file("./package.json", package_json())
    Mix.Generator.create_file("./webpack.config.js", webpack_config())
    Mix.Generator.create_file(".gitignore", gitignore())
  end

  defp gitignore do
    """
    # The directory Mix will write compiled artifacts to.
    /_build/

    # If you run "mix test --cover", coverage assets end up here.
    /cover/

    # The directory Mix downloads your dependencies sources to.
    /deps/

    # Where 3rd-party dependencies like ExDoc output generated docs.
    /doc/

    # Ignore .fetch files in case you like to edit your project deps locally.
    /.fetch

    # If the VM crashes, it generates a dump, let's ignore it too.
    erl_crash.dump

    # Also ignore archive artifacts (built via "mix archive.build").
    *.ez

    # If NPM crashes, it generates a log, let's ignore it too.
    npm-debug.log

    # The directory NPM downloads your dependencies sources to.
    /node_modules/
    # Since we are building assets from assets/,
    # we ignore priv/static. You may want to comment
    # this depending on your deployment strategy.
    /priv/static/

    # Files matching config/*.secret.exs pattern contain sensitive
    # data and you should not commit them into version control.
    #
    # Alternatively, you may comment the line below and commit the
    # secrets files as long as you replace their contents by environment
    # variables.
    /config/*.secret.exs
    """
  end

  def package_json do
    """
    {
      "repository": {},
      "description": " ",
      "license": "MIT",
      "scripts": {
        "deploy": "webpack --mode production",
        "watch": "webpack --mode development --watch"
      },
      "dependencies": {
        "phoenix": "file:deps/phoenix",
        "phoenix_html": "file:deps/phoenix_html"
      },
      "devDependencies": {
        "@babel/core": "^7.0.0",
        "@babel/preset-env": "^7.0.0",
        "babel-loader": "^8.0.0",
        "copy-webpack-plugin": "^4.5.0",
        "css-loader": "^0.28.10",
        "mini-css-extract-plugin": "^0.4.0",
        "optimize-css-assets-webpack-plugin": "^4.0.0",
        "terser-webpack-plugin": "^1.1.0",
        "webpack": "4.28.4",
        "webpack-cli": "^3.1.2"
      }
    }
    """
  end

  def webpack_config do
    """
    const path = require('path');
    const glob = require('glob');
    const MiniCssExtractPlugin = require('mini-css-extract-plugin');
    const TerserPlugin = require('terser-webpack-plugin');
    const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
    const CopyWebpackPlugin = require('copy-webpack-plugin');

    module.exports = (env, options) => ({
    optimization: {
    minimizer: [
      new TerserPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
    },
    entry: {
    app: './assets/js/app.js'
    },
    output: {
    filename: 'app.js',
    path: path.resolve(__dirname, 'priv/static/js')
    },
    stats: {
    colors: !/^win/i.test(process.platform)
    },
    module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader']
      }
    ]
    },
    plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'assets/static/', to: '../' }])
    ]
    });
    """
  end
end
