module.exports = {
  extends: [ "../../../build/node_modules/stylelint-plugin-stylus/standard", ],
  plugins: [ "../../../build/node_modules/stylelint-order", ],
  rules: {
    "order/properties-alphabetical-order": true
  },
};
