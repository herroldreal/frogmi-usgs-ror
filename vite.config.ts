import {defineConfig} from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

import {fileURLToPath, URL} from "node:url";
import FullReload from "vite-plugin-full-reload";
import vue from "@vitejs/plugin-vue";
import {visualizer} from "rollup-plugin-visualizer";
import vuetify from "vite-plugin-vuetify";

const plugins = [
    vue(),
    vuetify(),
    FullReload(["config/routes.rb", "app/views/**/*"]),
    RubyPlugin(),
];

if (process.env.VITE_RUBY_MODE === "development") {
    plugins.push(
        visualizer({
            open: false,
        })
    );
}

export default defineConfig({
    server: {
        open: 'http://localhost:3000'
    },
    resolve: {
        alias: {
            "vue": "vue/dist/vue.esm-bundler.js",
            "@": fileURLToPath(new URL("./app/javascript", import.meta.url)),
            "~": fileURLToPath(new URL("./app", import.meta.url)),
        },
        extensions: [
            ".mjs",
            ".js",
            ".ts",
            ".jsx",
            ".tsx",
            ".json",
            ".vue",
            ".sass",
            ".scss",
            ".css",
            ".png",
            ".svg",
        ],
    },
    appType: "mpa",
    clearScreen: false,
    plugins,
    optimizeDeps: {
        include: ['vuetify']
    }
})
