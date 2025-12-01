/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    // 1. MOVIMOS 'colors' FUERA DE 'extend'
    // Esto REEMPLAZA la paleta de colores de Tailwind.
    colors: {
      // 2. Tuvimos que volver a añadir estos colores básicos
      transparent: 'transparent',
      current: 'currentColor',
      white: '#ffffff',

      // 3. Aquí están TUS colores personalizados
      gray: {
        900: '#0f172a',
        800: '#1e293b',
        700: '#334155',
        400: '#9ca3af',
        300: '#d1d5db',
      },
      blue: {
        400: '#60a5fa',
        500: '#3b82f6',
        600: '#2563eb',
      },

      // 4. Colores que tu App.jsx necesita (para G, E, P y Errores)
      green: {
        400: '#4ade80', // text-green-400
      },
      yellow: {
        400: '#facc15', // text-yellow-400
      },
      red: {
        400: '#f87171', // text-red-400
        500: '#ef4444', // border-red-500
        900: '#7f1d1d', // bg-red-900
      }
    },
    
    // 'extend' ahora solo se usa para cosas que NO son colores
    extend: {
      backgroundImage: {
        'asfalt-dark': "url('https://www.transparenttextures.com/patterns/asfalt-dark.png')"
      }
    },
  },
  plugins: [],
}