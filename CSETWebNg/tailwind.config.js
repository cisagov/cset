/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        // CSET Brand Colors
        'cset-primary': '#003366',
        'cset-secondary': '#0066cc',
        'cset-accent': '#4CAF50',
        'cset-warning': '#FF9800',
        'cset-error': '#F44336',
        'cset-success': '#4CAF50',
        
        // Grayscale palette
        'gray-50': '#fafafa',
        'gray-100': '#f5f5f5',
        'gray-150': '#e8e8e8',
        'gray-200': '#eeeeee',
        'gray-300': '#e0e0e0',
        'gray-400': '#bdbdbd',
        'gray-500': '#9e9e9e',
        'gray-600': '#757575',
        'gray-700': '#616161',
        'gray-800': '#424242',
        'gray-900': '#212121',
      },
      fontFamily: {
        'roboto': ['Roboto', 'sans-serif'],
      },
    },
  },
  plugins: [
    require('daisyui'),
  ],
  daisyui: {
    themes: [
      {
        cset: {
          "primary": "#003366",
          "secondary": "#0066cc", 
          "accent": "#4CAF50",
          "neutral": "#616161",
          "base-100": "#ffffff",
          "base-200": "#f5f5f5",
          "base-300": "#e0e0e0",
          "info": "#2196F3",
          "success": "#4CAF50",
          "warning": "#FF9800",
          "error": "#F44336",
        },
      },
    ],
    base: true,
    styled: true,
    utils: true,
  },
};