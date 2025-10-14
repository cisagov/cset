import daisyui from "daisyui";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{html,ts}"],
  prefix: 'tw-',
  important: true,
  darkMode: ['class', '[data-theme="dark"]'], // Enable class-based dark mode with DaisyUI support
  theme: {
    extend: {
      colors: {
        // Custom CSET brand colors that work in both modes
        'cset-primary': '#015288',
        'cset-primary-dark': '#013a5f',
      },
    },
  },
  plugins: [daisyui],
  daisyui: {
    themes: [
      {
        light: {
          "primary": "#015288",
          "secondary": "#f0f0f0",
          "accent": "#37cdbe",
          "neutral": "#3d4451",
          "base-100": "#ffffff",
          "base-200": "#f9fafb",
          "base-300": "#e5e7eb",
          "info": "#3abff8",
          "success": "#36d399",
          "warning": "#fbbd23",
          "error": "#f87272",
        },
        dark: {
          "primary": "#015288",
          "secondary": "#1f2937",
          "accent": "#37cdbe",
          "neutral": "#2a323c",
          "base-100": "#1d232a",
          "base-200": "#191e24",
          "base-300": "#15191e",
          "info": "#3abff8",
          "success": "#36d399",
          "warning": "#fbbd23",
          "error": "#f87272",
        },
      },
    ],
  },
  corePlugins: {
    preflight: false, // Disable to avoid conflicts with Bootstrap
  },
};