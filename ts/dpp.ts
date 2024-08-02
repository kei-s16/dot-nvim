import {
  BaseConfig,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.1.0/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.1.0/deps.ts";

type Toml = {
  hooks_file?: string;
  ftplugins?: Record<string, string>;
  plugins: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<{
    plugins: Plugin[];
    stateLines: string[];
  }> {
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
    const basePath = Deno.build.os === "windows" ? "~/AppData/Local/nvim/toml/" : "~/.config/nvim/toml/";

    // Load toml plugins
    const tomls: Toml[] = [];

    // Non-Lazy
    for (
      const tomlFile of [
        "dpp.toml",
        "theme.toml",
        "i18n.toml",
      ]
    ) {
      const toml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: basePath + tomlFile,
          options: {
            lazy: false,
          },
        },
      ) as Toml | undefined;

      if (toml) {
        tomls.push(toml);
      }
    }

    // Lazy
    for (
      const tomlFile of [
        "ddc.toml",
        "ddu.toml",
        "git.toml",
        "lsp.toml",
        "etc.toml",
      ]
    ) {
      const toml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: basePath + tomlFile,
          options: {
            lazy: true,
          },
        },
      ) as Toml | undefined;

      if (toml) {
        tomls.push(toml);
      }
    }

    // Merge toml results
    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];
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

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult | undefined;

    return {
      ftplugins,
      hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
