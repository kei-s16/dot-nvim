import {
  type ContextBuilder,
  type ExtOptions,
  type Plugin,
} from "jsr:@shougo/dpp-vim@~4.1.0/types";
import {
  BaseConfig,
  type ConfigReturn,
  type MultipleHook,
} from "jsr:@shougo/dpp-vim@~4.1.0/config";
import { Protocol } from "jsr:@shougo/dpp-vim@~4.1.0/protocol";

import type { Denops } from "jsr:@denops/std@~7.4.0";

import type {
  Ext as TomlExt,
  Params as TomlParams,
} from "jsr:@shougo/dpp-ext-toml@~1.3.0";
import type {
  Ext as LocalExt,
  Params as LocalParams,
} from "jsr:@shougo/dpp-ext-local@~1.3.0";
import type {
  Ext as LazyExt,
  LazyMakeStateResult,
  Params as LazyParams,
} from "jsr:@shougo/dpp-ext-lazy@~1.5.0";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
  }): Promise<ConfigReturn> {
    args.contextBuilder.setGlobal({
      extParams: {
        installer: {
          checkDiff: true,
          logFilePath: "~/.cache/dpp/installer-log.txt",
        },
      },
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const protocols = await args.denops.dispatcher.getProtocols() as Record<
      string,
      Protocol
    >;
    const basePath = Deno.build.os === "windows" ? "~/AppData/Local/nvim/toml/" : "~/.config/nvim/toml/";
    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];

    // tomlにあるやつ全部読む
    const [tomlExt, tomlOptions, tomlParams]: [
      TomlExt | undefined,
      ExtOptions,
      TomlParams,
    ] = await args.denops.dispatcher.getExt("toml") as [TomlExt | undefined, ExtOptions, TomlParams];

    if (tomlExt) {
      const action = tomlExt.actions.load;

      const tomlPromises = [
        { path: basePath + "dpp.toml", lazy: false},
        { path: basePath + "theme.toml", lazy: false},
        { path: basePath + "i18n.toml", lazy: false},
        { path: basePath + "ddc.toml", lazy: true},
        { path: basePath + "ddu.toml", lazy: true},
        { path: basePath + "git.toml", lazy: true},
        { path: basePath + "lsp.toml", lazy: true},
        { path: basePath + "etc.toml", lazy: true},
      ].map((toml) => action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: tomlOptions,
        extParams: tomlParams,
        actionParams: {
          path: toml.path,
          options: {
            lazy: toml.lazy
          }
        }
      }));

      const tomls = await Promise.all(tomlPromises);

      // tomlに書いてあることいい感じに格納する
      for (const toml of tomls) {
        for (const plugin of toml.plugins ?? []) {
          recordPlugins[plugin.name] = plugin;
        }

        if (toml.ftplugins) {
          for (const filetype of Object.keys(toml.ftplugins)) {
            if (ftplugins[filetype]) {
              ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
            } else {
              ftplugins[filetype] = toml.ftplugins[filetype];
            }
          }
        }

        if (toml.hooks_file) {
          hooksFiles.push(toml.hooks_file);
        }
      }
    }

    // ローカルの開発中 or forkしたプラグイン読む
    const [localExt, localOptions, localParams]: [
      LocalExt | undefined,
      ExtOptions,
      LocalParams,
    ] = await args.denops.dispatcher.getExt("local") as [LocalExt | undefined, ExtOptions, LocalParams];
    if (localExt) {
      const action = localExt.actions.local;

      const plugins = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: localOptions,
        extParams: localParams,
        actionParams: {
          directory: "~/tmp/vim-dev",
          options: {
            merged: false,
          }
        },
      });

      for (const plugin of plugins) {
        // すでに読み込んであったらdpp-ext-localで取ってきたやつ優先
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = Object.assign(
            recordPlugins[plugin.name],
            plugin,
          );
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
    }

    // lazyloadまとめる
    const [lazyExt, lazyOptions, lazyParams]: [
      LazyExt | undefined,
      ExtOptions,
      LazyParams,
    ] = await args.denops.dispatcher.getExt("lazy") as [LazyExt | undefined, ExtOptions, LazyParams];
    let lazyResult: LazyMakeStateResult | undefined = undefined;
    if (lazyExt) {
      const action = lazyExt.actions.makeState;

      lazyResult = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: lazyOptions,
        extParams: lazyParams,
        actionParams: {
          plugins: Object.values(recordPlugins),
        }
      }) as LazyMakeStateResult | undefined;
    }

    return {
      ftplugins,
      hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}

