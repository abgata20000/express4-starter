locales = []
locales.push {lang: 'ja', name: '日本語'}
locales.push {lang: 'en', name: 'English'}

langs = []
for val in locales
  langs.push val.lang

module.exports.locales = locales
module.exports.langs = langs
