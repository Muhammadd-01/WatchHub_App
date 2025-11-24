/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./index.html",
        "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                primary: '#101820',
                accent: '#C59D5F',
                secondary: '#F7F7F7',
            }
        },
    },
    plugins: [],
}
