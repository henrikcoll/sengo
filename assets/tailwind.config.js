module.exports = {
  content: [
    './js/**/*.js',
    '../lib/sengo_web/**/*.*ex'
  ],
  theme: {
    extend: {},
  },
  variants: {},
  plugins: [require('@tailwindcss/forms')],
}
