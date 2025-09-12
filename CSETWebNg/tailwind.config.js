import daisyui from "daisyui";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{html,ts}"],
  prefix: 'tw-',
  important: true,
  theme: {
    extend: {},
  },
  plugins: [daisyui],
  daisyui: {
    themes: ["light", "dark"],
  },
  corePlugins: {
    preflight: false, // Disable to avoid conflicts with Bootstrap
  },
};